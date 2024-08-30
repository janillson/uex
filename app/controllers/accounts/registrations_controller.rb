class Accounts::RegistrationsController < Devise::RegistrationsController
  def confirm_destroy; end

  def destroy
    password = params[:account][:password]
    password_confirmation = params[:account][:password_confirmation]

    return redirect_to root_path, alert: 'Password and password confirmation do not match' if password != password_confirmation

    if current_account.valid_password?(password)
      super
    else
      return redirect_to root_path, alert: 'Password is incorrect'
    end
  end
end