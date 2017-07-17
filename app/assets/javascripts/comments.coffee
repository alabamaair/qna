$(document).on 'turbolinks:load', ->
  $('.add_comment_link').on 'click', (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId');
    $('form#add_comment_' + commentable_id).show();
