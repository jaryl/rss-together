Rails.application.routes.draw do
  root to: "reader#show"

  mount RssTogether::Engine => "/"
end
