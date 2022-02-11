RssTogether::Engine.routes.draw do
  devise_for :accounts, class_name: "RssTogether::Account", module: :devise

  # resources :groups, only: [:index] do
  #   resources :feeds, only: [:index] do
  #     resources :items, only: [:show] do
  #       resource :bookmarks, only: [:create, :destroy]
  #       resource :reaction, only: [:create, :update]
  #       resources :comments, only: [:index, :create, :edit ,:update, :destroy]
  #     end
  #   end
  # end

  # resources :bookmarks, only: [:index, :show]

  # namespace :my do
  #   resource :account, only: [:show, :update, :destroy] do
  #     resource :cancel, only: [:show, :destroy]
  #   end

  #   resources :groups, only: [:index, :new, :create, :edit, :update] do
  #     resource :leave, only: [:show, :destroy]
  #     resource :delete, only: [:show, :destroy]

  #     resources :invitations, only: [:index, :new, :create, :destroy]
  #     resources :members, only: [:index, :destroy]

  #     resources :subscriptions, only: [:index, :new, :create, :destroy]
  #   end
  # end
end
