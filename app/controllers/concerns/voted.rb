module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :unvote]
    before_action :render_error_author, only: [:vote_up, :vote_down]
    before_action :render_error_double, only: [:vote_up, :vote_down]
  end

  def vote_up
    vote = @votable.votes.build(user_id: current_user.id, value: 1)
    if vote.save
      render_success
    else
      render_error
    end
  end

  def vote_down
    vote = @votable.votes.build(user_id: current_user.id, value: -1)
    if vote.save
      render_success
    else
      render_error
    end
  end

  def unvote
    @votable.votes.where(:user_id == current_user.id).destroy_all
    render_success
  end

  # def label_vote
  #   "#{@votable.class.name.underscore}_#{@votable.id}"
  # end

  private

  def render_success
    render json: { label_vote: @votable.label_vote, rating: @votable.rating }
  end

  def render_error
    render json: 'Error voting.', status: :unprocessable_entity
  end

  def render_error_author
    render json: 'Sorry, it is not possible, sir, you\'re author.', status: :forbidden if current_user.author? @votable
  end

  def render_error_double
    render json: 'Sorry, you already voted.', status: :forbidden if current_user.voted_for? @votable
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
