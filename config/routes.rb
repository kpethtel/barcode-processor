Rails.application.routes.draw do
  resources :users

  resources :barcodes do
    collection do
      get :import
      post :import, to: 'barcodes#upload'
      post :generate
    end
  end

  root to: "pages#root"
end
