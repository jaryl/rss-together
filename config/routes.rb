RssTogether::Engine.routes.draw do
  devise_for :accounts, class_name: "RssTogether::Account", skip: [:registrations, :password], module: :devise

  devise_scope :account do
    resource :registration, only: [:new, :create], controller: "/devise/registrations", as: :account_registration
    resource :password, only: [:new, :create], controller: "/devise/passwords"
  end

  root to: "dashboards#show"

  resources :groups, only: [:index] do
    # resources :feeds, only: [:index] do
    #   resources :items, only: [:show] do
    #     resource :bookmarks, only: [:create, :destroy]
    #     resource :reaction, only: [:create, :update]
    #     resources :comments, only: [:index, :create, :edit ,:update, :destroy]
    #   end
    # end
  end

  resources :bookmarks, only: [:index, :show]

  resource :join, only: [:show, :create]

  namespace :my do
    devise_scope :account do
      resource :registration,
        only: [:edit, :update, :destroy],
        controller: "/devise/registrations",
        path: "account",
        path_names: { edit: "/" }
    end

    resources :groups, only: [:index, :new, :create, :edit, :update, :destroy] do
      # resource :leave, only: [:show, :destroy]

      scope module: :groups do
        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]
        resources :subscriptions, only: [:index, :new, :create, :destroy]
      end
    end
  end
end
