import consumer from "./consumer"

$(document).on('turbolinks:load', function(){  
  if ($('.questions-list').data("action") == "questions_index") {
    consumer.subscriptions.create("QuestionsChannel", {
      received(data) {      
        this.prependQuestion(data)
      },

      prependQuestion(data) {
        const questionPartial = this.createQuestionParshial(data)
        $('.questions-list').prepend(questionPartial)
      },

      createQuestionParshial(data) {
        const question = JSON.parse(data)

        const $questionDiv = $("<div>", {
          id: `question_${question.id}`,
          class: "question-list bg-white border shadow shadow-sm p-3 rounded mb-3"
        })
          .append(`
                    <p>
                      <a href="/questions/${question.id}">
                      ${question.title}
                      </a>
                    </p>                
                  `)
      
        const $voutingDiv = $("<div>", {
          id: `vouting_question_${question.id}`,
          class: "vouting"
        }).append(`<div class="rating me-2">${question.rating}</div> `)
      
        const linkToDelete = `
          <a  class="btn btn-sm btn-outline-danger mb-3" rel="nofollow"
              data-method="delete" href="/questions/${question.id}">
            Delete this question
          </a>
        ` 
        const voutingLinks = `
          <a  class="link-voute link-upvote  me-2" data-type="json"
              data-remote="true" rel="nofollow" data-method="patch"
              href="/questions/${question.id}/upvote">
            Like
          </a>
          
          <a  class="link-voute link-downvote " data-type="json"
              data-remote="true" rel="nofollow" data-method="patch"
              href="/questions/${question.id}/downvote">
            Dislike
          </a>
        `
        if (gon.current_user_id) {
          $voutingDiv.append(voutingLinks)
        }
      
        if (gon.current_user_id == question.author_id) {
          $questionDiv.append(linkToDelete)
        }

        return  $questionDiv.append($voutingDiv)       
      }
    });
  }
})

