# -*- encoding : utf-8 -*-
Valhal::Application.routes.draw do

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.
  get "view_file/show"

  resources :vocabularies
  resources :basic_files do
    member do
      get 'show'
      get 'download'
      get 'administration'
      patch 'update_administration'
      get 'preservation'
      patch 'characterize_file'
      patch 'update_preservation_profile'
      get 'edit_permission'
      patch 'update_permission'
    end
  end

  #Standard resource mapping
  resources :single_file_instances do
    member do
      get 'administration'
      patch 'update_administration'
      get 'preservation'
      patch 'update_preservation_profile'
      get 'show_mods'
      get 'edit_permission'
      patch 'update_permission'
    end
  end

  resources :ordered_instances do
    member do
      get 'thumbnail_url'
      get 'download_all'
      get 'administration'
      patch 'update_administration'
      get 'preservation'
      patch 'update_preservation_profile'
      get 'show_mods'
      get 'edit_permission'
      patch 'update_permission'
    end
  end

  get "works/new_from_mods"
  post "works/create_from_mods"
  resources :works do
    member do
      put 'create_structmap'
      put 'finish_work_with_structmap'
      patch 'update_agent'
      get 'show_agent'
      patch 'update_metadata'
      get 'show_metadata'
      patch 'update_file'
      get 'show_file'
      patch 'save_edit'
      get 'administration'
      patch 'update_administration'
      get 'preservation'
      patch 'update_preservation_profile'
      get 'dissemination'
      patch 'send_to_dissemination'
      get 'show_mods'
      get 'get_admin_material_types'
    end
  end


  resources :authority_metadata_units do
  end
end
