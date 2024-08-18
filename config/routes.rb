Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "signup", to: "users#signup"
  post "login", to: "users#login"
  post "send_reset_password_email", to: "users#send_reset_password_email"
  put "reset_password/:reset_password_token", to: "users#reset_password"
  delete "logout", to: "users#logout"
  delete "delete_account", to: "users#delete_account"
end
