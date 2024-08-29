Rails.application.routes.draw do
  root "home#index"

  devise_for :accounts

  devise_scope :account do
    get :confirm_destroy, to: 'accounts/registrations#confirm_destroy', as: :confirm_destroy_account
  end
end
