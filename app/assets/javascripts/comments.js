$(document).on('turbolinks:load', function(){
  $('.new-comment').on('ajax:success', function(e) {
    e.currentTarget.reset()

    const comment = e.detail[0].comment

    const commentBody = comment.body
    const $commentPartial = $("<div>", {
                                class: "comment col-6 ms-5 mb-2 p-2 border rounded text-secondary"
                              }).append(commentBody)

    const commentResourceType = comment.commentable_type.toLowerCase()
    const commentResourceId = comment.commentable_id
    const resourceDiv = `#${commentResourceType}_${commentResourceId}`
    $('.comments', resourceDiv).prepend($commentPartial)

    $(this).toggleClass('hidden')    
  })
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors
      $.each(errors, function(index, value) {
        $('.comments').append(value)
      })
    })

  $('a.comment-btn').on('click', function(e) {
    e.preventDefault()
    const form = $('form', this.parentElement)
    form.toggleClass('hidden')
  })
})

