$(document).on('turbolinks:load', function(){

  $('.new-comment').on('ajax:success', function(e) {
    e.currentTarget.reset()

    const commentBody = e.detail[0].comment.body
    const commentResourceType = e.detail[0].comment.commentable_type.toLowerCase()
    const commentResourceId = e.detail[0].comment.commentable_id

    // create partial for comment
    const $commentPartial = $("<div>", {
      class: "comment col-6 ms-5 mb-2 p-2 border rounded text-secondary"
    })
      .append(commentBody)

    // insert comment partial to resource comments
    const resourceDiv = `#${commentResourceType}_${commentResourceId}`
    $('.comments', resourceDiv).append($commentPartial)
    
  }) // need refactor - send from voted res_type, res_id
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors

      $.each(errors, function(index, value) {
        $('.comments').append(value)
      })
    })


  // Answer comments  
  $('a.comment-btn').on('click', function(e) {
    e.preventDefault()

    const answerId = $(this).data('resourceId')

    const form = document.getElementById('new-comment')

    form.setAttribute('action', `/answers/${answerId}/create_comment`)
    form.setAttribute('id', `answer-${answerId}-new-comment`)

    
    console.log(form.getAttribute('action'))
    e.currentTarget.parentElement.append(form)



  })
})

