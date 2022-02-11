RssTogether::Engine.routes.draw do
  devise_for :accounts, class_name: "RssTogether::Account", module: :devise
end
