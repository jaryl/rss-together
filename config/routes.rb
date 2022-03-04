RssTogether::Engine.routes.draw do
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
    resources :groups, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      scope module: :groups do
        resource :membership, only: [:show, :edit, :update, :destroy]
        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]
        resources :subscriptions, only: [:index, :new, :create, :destroy]
      end
    end
  end
end
