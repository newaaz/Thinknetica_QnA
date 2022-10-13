require 'rails_helper'

RSpec.describe NewAnswerNotifyService do
  let(:users)     { create_list(:user, 2) }
  let(:question)  { create(:question, subscribers: users) }
  let(:answer)    { create(:answer, question: question) }
  subject         { NewAnswerNotifyService.new }

  it 'send notification about new answer on subscribed question' do
    answer.question.subscribers.each { |user| expect(NewAnswerNotifyMailer).to receive(:notify).with(user, answer).and_call_original }
    subject.send_notify(answer)
  end
end
