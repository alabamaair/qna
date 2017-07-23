class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :shared_sign_in

  def twitter; end

  def facebook; end

  private

  def shared_sign_in
    @user = User.from_omniauth(auth)

    if @user.try(:persisted?)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Please enter your email to complete the login'
      render 'omniauth_callbacks/enter_email', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end
