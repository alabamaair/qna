class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "/questions/#{data['question_id']}/comments"
  end

  def unfollow
    stop_all_streams
  end
end
