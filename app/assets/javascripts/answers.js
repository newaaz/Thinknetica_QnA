$(document).on('turbolinks:load', function(){
  // Edit answer
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    $(this).hide()
    $('.cancel-edit-answer-link').show()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).show()
    $('#answer_' + answerId + ' .purge-link').show()

  })

  $('.answers').on('click', '.cancel-edit-answer-link', function(e) {
    e.preventDefault()
    $(this).hide()
    $('.edit-answer-link').show()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).hide()
    $('#answer_' + answerId + ' .purge-link').hide()
  })
})

