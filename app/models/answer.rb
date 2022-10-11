class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :author, class_name: 'User', inverse_of: :authored_answers
  belongs_to :question

  # TODO: fix destroy question with best answer
  #has_one :checked_best_on_question, class_name: 'Question', 
  #belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true

  has_many :links, as: :linkable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached  :files

  validates :body, :question_id, presence: true

  after_create :send_notifications

  private

  def send_notifications
    NewAnswerNotifyJob.perform_later(self)
  end
end
