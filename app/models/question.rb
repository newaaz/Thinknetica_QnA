class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :authored_questions
  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true
  has_many :answers, dependent: :destroy

  has_many_attached  :files
  
  validates :title, :body, presence: true

  def append_files(added_files)
    files.attach(added_files)
  end
end
