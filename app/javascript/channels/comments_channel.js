import consumer from "./consumer"

$(document).on('turbolinks:load', function(){  

  if (gon.question_id) {

    consumer.subscriptions.create({channel: "CommentsChannel", question_id: gon.question_id}, {
      
      received(data) {   
        const authorComment = JSON.parse(data).user_id

        if (authorComment != gon.current_user_id) {
          this.appendComment(data)
        }        
      },

      appendComment(data) {
        const commentPartial = this.createCommentPartial(data)
        
        $('.comments').append(commentPartial)
      },

      createCommentPartial(data) {
        const commentBody = JSON.parse(data).body               

        const commentDiv = $("<div>", {
          class: "comment col-6 ms-5 mb-2 p-2 border rounded text-secondary"
        })
          .append(commentBody)

        return  commentDiv

      }
    });

  }

})

