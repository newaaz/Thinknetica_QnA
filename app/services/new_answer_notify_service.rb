class NewAnswerNotifyService
  def self.send_notify(answer)
    subscribers = answer.question.subscribers

    subscribers.find_each(batch_size: 500) do |subscriber|
      NewAnswerNotifyMailer.notify(subscriber, answer).deliver_later
    end
  end
end
