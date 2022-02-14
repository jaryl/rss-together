RssTogether::Engine.routes.draw do
  devise_for :accounts, class_name: "RssTogether::Account", skip: [:registrations, :password], module: :devise

  devise_scope :account do
    resource :registration, only: [:new, :create], controller: "/devise/registrations", as: :account_registration
    resource :password, only: [:new, :create], controller: "/devise/passwords", as: :account_password
  end

  root to: "dashboards#show"

  # resource :reader, only: [:show]

  resources :groups, only: [:index, :destroy] do
    # resources :feeds, only: [:index]
  end

  # resources :items, only: [:show] do
  #   scope module: :items do
  #     resource :bookmarks, only: [:create]
  #     resource :reaction, only: [:create, :update]
  #     resources :comments, only: [:index, :new, :create, :edit ,:update, :destroy]
  #   end
  # end

  resources :bookmarks, only: [:index, :show, :destroy]

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
      scope module: :groups do
        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]
        resources :subscriptions, only: [:index, :new, :create, :destroy]
      end
    end
  end
end
