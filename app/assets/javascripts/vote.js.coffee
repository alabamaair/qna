vote_success = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  votable_id = votable.id
  $('#rating_' + votable_id).html("Rating: " + votable.rating)
  $('.vote-errors').html('')
  $('#vote_' + votable_id).find( "*" ).toggle()

vote_error = (e, xhr, status, error) ->
  votable = $.parseJSON(xhr.responseText)
  votable_id = votable.id
  $('#vote-errors_' + votable_id).html(votable.error_message)


$(document).on 'ajax:success', '.voting', vote_success
$(document).on 'ajax:error', '.voting', vote_error