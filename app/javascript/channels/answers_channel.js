import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  if (gon.question_id) {
    consumer.subscriptions.create({channel: "AnswersChannel", question_id: gon.question_id}, {
      received(data) {   
        const authorComment = JSON.parse(data).author_id

        if (authorComment != gon.current_user_id) {
          this.prependAnswer(data)
        } 
      },

      prependAnswer(data) {
        const answerPartial = this.createAnswerPartial(data)
        $('.answers').prepend(answerPartial);
      },

      addLinksToAnswer(links) {
        let linksList = ''

        $.each(links, function(index, link) {
          linksList += `<p><a href=${link.url}>${link.name}</a></p>`
        })

        return linksList
      },

      createAnswerPartial(data) {
        const answer = JSON.parse(data)     
        
        const $answerDiv = $("<div>", {
          id: `question_${answer.id}`,
          class: "answer bg-white border shadow shadow-sm p-3 rounded mb-3"
        }).append(`<p>${answer.body}</p>`)

        const $voutingDiv = $("<div>", {
          id: `vouting_answer_${answer.id}`,
          class: "vouting"
        }).append(`<div class="rating me-2">${answer.rating}</div> `)      
 
        const voutingLinks = `
          <a  class="link-voute link-upvote  me-2" data-type="json"
              data-remote="true" rel="nofollow" data-method="patch"
              href="/answers/${answer.id}/upvote">
            Like
          </a>
          
          <a  class="link-voute link-downvote " data-type="json"
              data-remote="true" rel="nofollow" data-method="patch"
              href="/answers/${answer.id}/downvote">
            Dislike
          </a>
        `
        if (answer.links.length > 0) {
          $answerDiv.append(this.addLinksToAnswer(answer.links))
        }

        if (gon.current_user_id) {
          $voutingDiv.append(voutingLinks)
        }

        return $answerDiv.append($voutingDiv)
      }
    });
  } 
})



