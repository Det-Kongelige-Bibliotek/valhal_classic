# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController
  #You don't need login to view catalog
  skip_authorization_check

  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Controller::ControllerBehavior

  # Alwb: I have comment out all hydra access controls with "###" because it isnt setup yet
  # These before_filters apply the hydra access controls
  ###before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  ###CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]

  def exclude_unwanted_models(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    unwanted_models.each do |model|
      solr_parameters[:fq] << "-has_model_ssim:\"#{model.to_class_uri}\""
    end
  end

  def unwanted_models
    [BasicFile, TiffFile, OrderedInstance, SingleFileInstance]
  end

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10 
    }

    # solr field configuration for search results/index views
    work_solr_names = Work.solr_names
    config.index.show_link = work_solr_names[:search_result_title]
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = work_solr_names[:search_result_title]
    config.show.heading = work_solr_names[:search_result_title]
    config.show.display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = work_solr_names[:search_result_work_type]
    config.show.heading = work_solr_names[:search_result_work_type]
    config.show.display_type = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar

    config.add_facet_field work_solr_names[:search_result_work_type], :label => 'Work Types', :sort => 'index'


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'surname_t', :label => 'Lastname:'
    config.add_index_field 'forename_t', :label => 'Firstname:'
    config.add_index_field 'birth_date_t', :label => 'Date of Birth:'
    config.add_index_field 'death_date_t', :label => 'Date of Death:'
    config.add_index_field 'original_filename_t', :label => 'Name:'
    #config.add_index_field 'title_t', :label => 'Titel:'
    #config.add_index_field 'person_name_t', :label => 'Person Name:'
    config.add_index_field work_solr_names[:search_result_work_type] , :label => "Type of work:"

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    #config.add_show_field 'description_t', :label => 'Description:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    config.add_search_field 'all_fields', :label => 'All Fields'
    
    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end
end
