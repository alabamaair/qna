class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :shared_sign_in

  def twitter; end

  def facebook; end

  private

  def shared_sign_in
    @auth = request.env['omniauth.auth'] || new_auth
    @user = User.from_omniauth(@auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize) if is_navigational_format?
    elsif @auth.provider
      session['provider'] = @auth.provider
      session['uid'] = @auth.uid
      flash[:notice] = 'Please enter your email to complete the login'
      render 'omniauth_callbacks/enter_email'
    else
      redirect_to new_user_registration_path
      flash[:alert] = 'Error authenticate with providers.'
    end
  end

  def new_auth
    OmniAuth::AuthHash.new(provider: session['provider'], uid: session['uid'], info: { email: params[:email] })
  end
end
