class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :authored_answers
  belongs_to :question

  validates :body, :question_id, presence: true
end
