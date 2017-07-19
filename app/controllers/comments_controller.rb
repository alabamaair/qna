class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :set_question_id, only: :create

  after_action :publish_comments, only: :create

  respond_to :js

  def create
    respond_with @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  def destroy
    @comment = Comment.find params[:id]
    respond_with @comment.destroy if current_user.author?(@comment)
  end

  private

  def load_commentable
    @commentable = commentable_name.find(params[commentable_id])
  end

  def commentable_id
    (params[:commentable].singularize + '_id').to_sym
  end

  def commentable_name
    params[:commentable].classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_question_id
    @question_id = @commentable.class == Question ? @commentable.id : @commentable.question_id
  end

  def publish_comments
    return if @comment.errors.any?

    ActionCable.server.broadcast("/questions/#{@question_id}/comments",
                                 comentable_id: @comment.commentable_id,
                                 comment: @comment,
                                 commentable_klass: @commentable.class.name)
  end
end
