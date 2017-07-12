createAnswerChannel = ->
  unless $("[data-question]").length == 0
    questionId = $("[data-question]").data().question
    App.answer = App.cable.subscriptions.create { channel: "AnswersChannel", question_number: questionId },
      connected: ->
        questionId = $("[data-question]").data().question
        @perform 'follow', question_id: questionId

      received: (data) ->
        switch data['method']
          when 'publish' then @publish_answer(data)

      publish_answer: (data) ->
        $('.answers').append(JST["templates/answer"]({
          answer: data['answer'],
          attachments: data['attachments'],
          rating: data['rating'],
          commentable_id: data['answer'].id,
          question_user_id: data['question_user_id'],
          commentable_klass: 'Answer'
        }))

$(document).on("turbolinks:load", createAnswerChannel)
