RssTogether::Engine.routes.draw do
  devise_for :accounts, class_name: "RssTogether::Account", skip: [:registrations, :password], module: :devise

  devise_scope :account do
    resource :registration, only: [:new, :create], controller: "/devise/registrations", as: :account_registration
    resource :password, only: [:new, :create], controller: "/devise/passwords", as: :account_password
  end

  root to: "dashboards#show"

  resource :reader, only: [:show], controller: "/rss_together/reader" do
    scope module: :reader do
      resources :groups, only: [:index] do
        resources :items, only: [:index, :show] do
          resource :mark, only: [:show, :create, :destroy]
          resource :bookmark, only: [:show, :create, :destroy]
          resource :reaction, only: [:show, :edit, :update, :destroy]
          # resources :comments, only: [:index, :new, :create, :edit ,:update, :destroy]
        end
      end
    end
  end

  resources :bookmarks, only: [:index, :show, :destroy]

  resource :join, only: [:show, :create]

  namespace :my do
    devise_scope :account do
      resource :registration,
        only: [:edit, :update, :destroy],
        controller: "accounts",
        path: "account",
        path_names: { edit: "/" },
        as: :account
    end

    resources :groups, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      scope module: :groups do
        resource :membership, only: [:edit, :update, :destroy]
        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]
        resources :subscriptions, only: [:index, :new, :create, :destroy]
      end
    end
  end
end
