class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment.attachable.user_id == current_user.id
      @attachment.destroy
      flash[:notice] = 'Attachment successfully deleted'
    else
      flash[:error] = 'Attachment not deleted'
    end
  end
end
