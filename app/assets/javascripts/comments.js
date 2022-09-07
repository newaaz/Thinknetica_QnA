$(document).on('turbolinks:load', function(){

  $('.new-comment-question').on('ajax:success', function(e) {
    e.currentTarget.reset()

    const commentBody = e.detail[0].comment.body

    const $commentPartial = $("<div>", {
      class: "comment col-6 ms-5 mb-2 p-2 border rounded text-secondary"
    })
      .append(commentBody)

    $('.question-comments').append($commentPartial)    
  })
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors

      $.each(errors, function(index, value) {
        $('.question-comments').append(value)
      })
    })
})

