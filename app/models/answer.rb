class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :author, class_name: 'User', inverse_of: :authored_answers
  belongs_to :question, touch: true

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
