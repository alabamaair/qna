createCommentsChannel = ->
  unless $("[data-question]").length == 0
    questionId = $("[data-question]").data().question
    App.comment = App.cable.subscriptions.create { channel: "CommentsChannel", question_number: questionId },
      connected: ->
        questionId = $("[data-question]").data().question
        @perform 'follow', question_id: questionId

      received: (data) ->
        $('#commentable_'+ data['commentable_klass'] + '_' + data['comentable_id']).append(JST["templates/comments/comment"]({
          comment: data['comment'],
        }))

$(document).on("turbolinks:load", createCommentsChannel)