# -*- encoding : utf-8 -*-
module Datastreams
  # Workflow datastream. Contains basic information about the workflow - name and any errors - and all the steps.
  class WorkflowDatastream < ActiveFedora::OmDatastream
    set_terminology do |t|
      t.root(path: 'fields')
      t.workflow_name(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable],
                               :path => 'workflow_name', :label => 'Workflow name')
      t.workflow_error(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable],
                               :path => 'workflow_error', :label => 'Workflow error')
      t.workflow_last_update(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable],
                             :path => 'workflow_last_update', :label => 'Workflow last update')

      t.step do
        t.name()
        t.state()
        t.function()
      end
    end

    define_template :step do |xml, val|
      xml.step() {
        xml.name {xml.text(val['name'])}
        xml.state {val['state'].blank? ? xml.text(WorkflowService::WORKFLOW_STATE_NOT_STARTED) : xml.text(val['state'])}
        xml.function {xml.text(val['function'])}
      }
    end

    # Inserts a given step
    # @param val Must be a HashMap with 'name' and 'methods' (though 'methods' are optional)
    def insert_step(val)
      raise ArgumentError.new 'A new step must be defined in a Hash' unless val.is_a? Hash
      raise ArgumentError.new 'A step is required to have a name' if val['name'].blank?
      sibling = find_by_terms(:step).last
      node = sibling ? add_next_sibling_node(sibling, :step, val) :
          add_child_node(ng_xml.root, :step, val)
      content_will_change!
      return node
    end

    # Removes all the steps.
    def remove_step
      nodes = find_by_terms(:step)
      if (nodes.size>0)
        nodes.each { |n| n.remove }
        content_will_change!
      end
    end

    # Retrieves all the steps.
    def get_step
      step = []
      nodes = find_by_terms(:step)
      nodes.each do |n|
        at = Hash.new
        n.children.each do |c|
          at[c.name] = c.text unless c.name == 'text'
        end
        step << at
      end
      step
    end

    def self.xml_template
      Nokogiri::XML.parse('<fields/>')
    end
  end
end