Rails.application.routes.draw do
  root to: "reader#show"

  resource :reader

  mount RssTogether::Engine => "/"
end
