# -*- encoding : utf-8 -*-
Valhal::Application.routes.draw do
  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  # The priority is based upon order of creation:
  # first created -> highest priority.
  get "view_file/show"
  get "view_file/show_structmap"

  resources :basic_files do
    member do
      get 'show'
      get 'download'
      get 'preservation'
      put 'update_preservation_profile'
    end
  end

  #Standard resource mapping
  resources :single_file_representations do
    member do
      get 'preservation'
      put 'update_preservation_profile'
    end
  end

  resources :ordered_representations do
    member do
      get 'thumbnail_url'
      get 'download_all'
      get 'preservation'
      put 'update_preservation_profile'
    end
  end

  resources :works  do
    member do
      put 'new'
      put 'update_person'
      get 'show_person'
      put 'update_metadata'
      get 'show_metadata'
      put 'update_file'
      get 'show_file'
      put 'save_edit'
      get 'preservation'
      put 'update_preservation_profile'
    end
  end

  resources :people do
    member do
      get 'show_image'
      get 'image_url'
      put 'add_manifest'
      get 'preservation'
      put 'update_preservation_profile'
    end
  end

  resources :books do
    member do
      put 'create_structmap'
      put 'new'
      patch 'update_person'
      get 'show_person'
      patch 'update_metadata'
      get 'show_metadata'
      patch 'update_file'
      get 'show_file'
      patch 'save_edit'
      put 'finish_book_with_structmap'
      get 'preservation'
      put 'update_preservation_profile'
    end
  end
end
