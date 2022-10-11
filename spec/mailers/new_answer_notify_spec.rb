require "rails_helper"

RSpec.describe NewAnswerNotifyMailer, type: :mailer do
  describe 'notify' do
    let(:question)  { create(:question) }
    let(:answer)    { create(:answer, body: 'check notification', question: question) }
    let(:user)      { create(:user) }
    let(:mail)      { NewAnswerNotifyMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer on #{answer.question.title}")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end
  
    it "renders the body" do
      expect(mail.body.encoded).to match("New answer:")
    end
  end
end
