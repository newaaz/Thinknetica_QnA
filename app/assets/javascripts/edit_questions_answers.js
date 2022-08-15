$(document).on('turbolinks:load', function(){
  // Edit question
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault()
    $(this).hide()
    $('.cancel-edit-question-link').show()
    $('form#edit-question').removeClass('hidden')
    $('.purge-link', '.question').removeClass('hidden')

  })

  $('.question').on('click', '.cancel-edit-question-link', function(e) {
    e.preventDefault()
    $(this).hide()
    $('.edit-question-link').show()
    $('.new-answer')[0].reset();
    $('form#edit-question').addClass('hidden')
    $('.purge-link', '.question').addClass('hidden')
  })

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



console.log('I m from assets')

