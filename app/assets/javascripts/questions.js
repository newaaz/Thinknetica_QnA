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
})

