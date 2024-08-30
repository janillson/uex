Rails.application.routes.draw do
  root "contacts#index"

  devise_for :accounts

  devise_scope :account do
    get :confirm_destroy, to: 'accounts/registrations#confirm_destroy', as: :confirm_destroy_account
  end

  resources :contacts, only: %i[index show new create edit update destroy] do
    get :confirm_destroy, on: :member
  end

  scope '/autocomplete' do
    get :zipcode, to: 'autocomplete#zipcode', as: :zipcode
    get :addresses, to: 'autocomplete#addresses', as: :addresses
    get :pins, to: 'autocomplete#pins', as: :pins
    get :contacts, to: 'autocomplete#contacts', as: :contact_list
  end
end
