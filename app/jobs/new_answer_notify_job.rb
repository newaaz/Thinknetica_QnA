class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotifyService.new.send_notify(answer)
  end
end
