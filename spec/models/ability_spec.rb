require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)          { create :user }
    let(:another_user)  { create :user }
    let(:question)      { create :question, author_id: user.id }
    let(:other_question) { create :question, author_id: another_user.id }
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should     be_able_to %i[update destroy], create(:question, author_id: user.id) }
    it { should_not be_able_to %i[update destroy], create(:question, author_id: another_user.id) }

    it { should     be_able_to %i[update destroy], create(:answer, author_id: user.id) }
    it { should_not be_able_to %i[update destroy], create(:answer, author_id: another_user.id) }

    context 'vote' do
      it { should     be_able_to %i[upvote downvote], create(:question, author_id: another_user.id) }
      it { should_not be_able_to %i[upvote downvote], create(:question, author_id: user.id) }

      it { should     be_able_to %i[upvote downvote], create(:answer, author_id: another_user.id) }
      it { should_not be_able_to %i[upvote downvote], create(:answer, author_id: user.id) }
    end

    context 'comments' do
      it { should be_able_to :create_comment, create(:question) }
      it { should be_able_to :create_comment, create(:answer) }
    end

    context 'links' do 
      it { should     be_able_to :destroy, create(:link, linkable: question, name: 'my link', url: 'https://preview.tabler.io/') }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question, name: 'my link', url: 'https://preview.tabler.io/') }
    end

    context 'set best answer' do
      it { should     be_able_to :set_best_answer, create(:question, author_id: user.id) }
      it { should_not be_able_to :set_best_answer, create(:question, author_id: another_user.id) }
    end

    context 'attachments' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'old_attachment.rb')
        other_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'old_attachment.rb')
      end

      it { should be_able_to :purge, question.files.last}
      it { should_not be_able_to :purge, other_question.files.last}
    end

    context 'subscriptions' do
      it { should be_able_to :subscribe, Question }
    end
  end

  describe 'for quest' do
    let(:user) { nil }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }  
  end
end
