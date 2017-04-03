$(document).on 'turbolinks:load', ->
  $('.edit-answer-link').on 'click', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();
  $('.best-answer').closest('.container-answer').find('.best-answer-button').hide();
