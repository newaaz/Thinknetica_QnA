class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :authored_questions
  has_many :answers, dependent: :destroy
  
  validates :title, :body, presence: true
end
