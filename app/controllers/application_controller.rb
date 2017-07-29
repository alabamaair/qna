require 'application_responder'

# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to root_path
      end
      format.any(:js, :json) { head :forbidden }
    end
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
