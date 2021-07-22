Rails.application.routes.draw do

  root 'welcome#index'
  get '/status' => 'welcome#index'

  namespace :v1 do
    
    # account
    resources :accounts, only: [:show, :update] do
      resource :consent, only: [] do
        post '/' => 'accounts#accept_consent'
      end
    end

    # deposit
    resources :deposits, only: [:create, :show, :update, :destroy] do
      
      resource :consent, only: [] do
        post '/' => 'deposits#accept_consent'
      end


    end

    # pricing
    resources :pricing, only: [:index]

    # payments
    resources :payments, only: [:show, :create]

  end # namespace :v1

end
