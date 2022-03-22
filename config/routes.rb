RssTogether::Engine.routes.draw do
  resource :join, only: [:show]

  constraints Rodauth::Rails.authenticated do
    namespace :reader do
      resources :bookmarks, only: [:index, :show]

      resources :groups, only: [:index] do
        resources :items, only: [:index, :show] do
          resource :mark, only: [:show, :create, :destroy]
          resource :bookmark, only: [:show, :create, :destroy]
          resource :reaction, only: [:show, :edit, :update, :destroy]
          # resources :comments, only: [:index, :new, :create, :edit ,:update, :destroy]
        end
      end
    end

    resources :bookmarks, only: [:index, :show, :destroy]

    namespace :settings do
      resource :email, only: [:show, :destroy]
      resource :profile, only: [:show, :edit, :update]
      resource :close, only: [:show]
      resources :invitations, only: [:index, :show] do
        post :accept, on: :member
        post :reject, on: :member
      end
    end

    resources :groups, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      scope module: "groups" do
        resource :membership, only: [:show, :edit, :update, :destroy]

        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]

        resources :subscriptions, only: [:index, :destroy]
        resources :subscriptions, only: [:new, :create], controller: "subscription_requests" do
          delete :cancel, on: :member
          get :processing, on: :collection
        end

        resource :transfer, only: [:show, :new, :create, :destroy] do
          resource :pending, only: [:show], controller: "pending_transfers" do
            post :accept
          end
        end
      end
    end
  end

  # constraints Rodauth::Rails.authenticated(:admin) do
  #   resources :profiles, only: [:index, :show]
  #   resources :groups, only: [:index, :show]
  #   resources :feeds, only: [:index, :show] do
  #     post :toggle
  #   end
  # end
end
