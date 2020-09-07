Rails.application.routes.draw do
  resources :users

  resources :barcodes do
    collection do
      get :import
    end
  end

  root to: "pages#root"
end
