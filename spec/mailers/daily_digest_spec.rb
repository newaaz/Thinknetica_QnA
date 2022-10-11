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
      # expect(mail.body.encoded).to match("Question for the check digest")
      # expect(mail.body.encoded).to have_link 'Question for the check digest', href: question_url(question)
      
    end

    it "assigns @questions.first in view to question" do
      # expect(assigns(:questions)).to eq question
    end
  end

end
