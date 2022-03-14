RssTogether::Engine.routes.draw do
  resource :join, only: [:show]

  constraints Rodauth::Rails.authenticated do
    root to: "reader#show"

    resource :reader, only: [:show], controller: "reader" do # TODO: extract into representational controller
      get :bookmarks # TODO: move into own controller

      scope module: :reader do
        resources :groups, only: [:index] do
          resources :items, only: [:index, :show] do
            resource :mark, only: [:show, :create, :destroy]
            resource :bookmark, only: [:show, :create, :destroy] # TODO: move out of groups
            resource :reaction, only: [:show, :edit, :update, :destroy]
            # resources :comments, only: [:index, :new, :create, :edit ,:update, :destroy]
          end
        end
      end
    end

    # namespace :reader do
    #   resources :bookmarks, only: [:index, :show]

    #   resources :groups, only: [:index] do
    #     resources :items, only: [:index, :show] do
    #       resource :mark, only: [:show, :create, :destroy]
    #       resource :bookmark, only: [:show, :create, :destroy]
    #       resource :reaction, only: [:show, :edit, :update, :destroy]
    #       # resources :comments, only: [:index, :new, :create, :edit ,:update, :destroy]
    #     end
    #   end
    # end

    resources :bookmarks, only: [:index, :show, :destroy]

    namespace :settings do
      resource :email, only: [:show, :destroy]
      resource :profile, only: [:show, :edit, :update]
      resource :close, only: [:show]
      resources :invitations, only: [:index, :show, :destroy]
    end

    resources :groups, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      scope module: "groups" do
        resource :membership, only: [:show, :edit, :update, :destroy]
        resources :invitations, only: [:index, :new, :create, :destroy]
        resources :members, only: [:index, :destroy]
        resources :subscriptions, only: [:index, :new, :create, :destroy]
        resource :transfer, only: [:show, :new, :create, :destroy] do
          # resource :accept, only: [:show, :create]
          get :pending
          post :accept
        end
      end
    end
  end
end
