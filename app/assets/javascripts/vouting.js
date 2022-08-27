$(document).on('turbolinks:load', function(){

  $('.link-voute').on('ajax:success', function(e) {
    const resourceName = e.detail[0].resource
    const resourceId = e.detail[0].id
    const resourceRating = e.detail[0].rating
    const resourceLiked = e.detail[0].liked

    const $resourceDiv = '#vouting_' + resourceName + '_' + resourceId

    $('.' + resourceName + '-rating', $resourceDiv).html(resourceRating)

    if (resourceLiked == 'true') {
      $('.link-upvote', $resourceDiv).addClass('enabled')
    } else {
      $('.link-upvote', $resourceDiv).removeClass('enabled')
    }

    if (resourceLiked == 'false') {
      $('.link-downvote', $resourceDiv).addClass('enabled')
    } else {
      $('.link-downvote', $resourceDiv).removeClass('enabled')
    }
  })
    .on('ajax:error', function(e) {
      const errors = e.detail[0].errors

      $.each(errors, function(index, value) {
        e.currentTarget.parentNode.append(value)
      })
    })
})

