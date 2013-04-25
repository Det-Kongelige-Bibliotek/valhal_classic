# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
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
  resources :works
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
    end
  end
end
