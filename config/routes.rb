# -*- encoding : utf-8 -*-
Valhal::Application.routes.draw do
  get "view_file/show"
  get "view_file/show_structmap"

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping
  resources :single_file_representations
  resources :ordered_representations do
    member do
      get 'thumbnail_url'
      get 'download_all'
    end
  end

  resources :works  do
    member do
      put 'new'
      put 'update_person'
      get 'show_person'
      put 'show_person'
      put 'update_metadata'
      get 'show_metadata'
      put 'show_metadata'
      put 'update_file'
      get 'show_file'
      put 'show_file'
      put 'save_edit'
    end
  end

  resources :people do
    member do
      get 'show_image'
      get 'image_url'
      put 'add_manifest'
    end
  end

  resources :books do
    member do
      put 'create_structmap'
      put 'new'
      put 'update_person'
      get 'show_person'
      put 'show_person'
      put 'update_metadata'
      get 'show_metadata'
      put 'show_metadata'
      put 'update_file'
      get 'show_file'
      put 'show_file'
      put 'save_edit'
      put 'finish_book_with_structmap'
    end
  end
end
