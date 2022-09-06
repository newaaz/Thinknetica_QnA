import consumer from "./consumer"

$(document).on('turbolinks:load', function(){

  if (gon.question_id) {

    consumer.subscriptions.create({channel: "AnswersChannel", question_id: gon.question_id}, {
      received(data) {   
        this.prependAnswer(data)
      },

      prependAnswer(data) {
        const answerPartial = this.createAnswerPartial(data)
        $('.answers').prepend(answerPartial);
      },

      createAnswerPartial(data) {
        const answer = JSON.parse(data)
        return answer.body
        //return "ttttttttttttttttttt"
      }


    });

  } 
})



