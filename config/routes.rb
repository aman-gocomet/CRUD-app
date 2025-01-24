Rails.application.routes.draw do
  root to: "main#index"

  namespace :api do
    namespace :user do
      get "get_users", to: "registration#get_all"
      post "sign_up", to: "registration#create"
      delete "delete", to: "registration#delete"
      patch "update", to: "registration#update"
    end
  end
end

