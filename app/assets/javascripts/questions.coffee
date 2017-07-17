# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  questionsList = $(".questions_list")

  $('.edit-question-link').on 'click', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();

  App.cable.subscriptions.create "QuestionsChannel", {
    connected: ->
      @follow()

    follow: ->
      @perform 'follow'

    received: (data) ->
      questionsList.empty() unless questionsList.find('.question_item').length
      questionsList.append data['question']
  }