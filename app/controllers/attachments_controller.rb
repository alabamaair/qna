class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    authorize @attachment
    respond_with @attachment.destroy if @attachment.attachable.user_id == current_user.id
  end

  def policy_class
    AttachmentPolicy
  end
end
