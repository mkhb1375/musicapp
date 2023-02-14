Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users , only:[:create , :new , :show , :edit , :update , :destroy] do
    collection do 
      
      get 'activate'
      post 'activate'

     
    end
    resource :link , only: [:edit , :update]
    resource :confirm , only: :show
    
  end

  resource :session , only:[:create , :new , :destroy]

  resources :bands do
    collection do 
      get 'search' 
       post 'search'
    end
    resource :confirm , only: :show
    resources :band_albums , only: :new

  end

  resources :band_albums ,except:[:new , :index] do
    resource :confirm , only: :show
    resources :tracks , only: :new

  end

  resources :tracks , except:[:new , :index]  do

    resource :confirm , only: :show

  end

  # Defines the root path route ("/")
  # root "articles#index"
  root "bands#index"
end
