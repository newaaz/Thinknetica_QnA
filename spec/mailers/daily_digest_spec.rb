require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:question)  { create(:question, title: 'Question for the check digest') }
    let(:user)      { create(:user) }
    let(:mail)      { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("QnA: New questions created yesterday")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Questions created yesterday")
    end
  end
end
