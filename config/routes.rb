# -*- encoding : utf-8 -*-
ADL::Application.routes.draw do
  resources :works


  get "view_file/show"

  root :to => "catalog#index"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  #Standard resource mapping
  resources :upload
  resources :book_tei_representations
  resources :book_tiff_representations do
    member do
      get 'show_all'
    end
  end
  resources :person_tei_representations
  resources :people do
    member do
      get 'show_image'
      get 'image_url'
    end
  end
  resources :books
  #resources :view_file
end
