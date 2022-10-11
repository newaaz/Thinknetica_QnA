class NewAnswerNotifyMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    mail to: user.email, subject: "New answer on #{answer.question.title}"
  end
end
