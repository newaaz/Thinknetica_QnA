class Question < ApplicationRecord
  include Votable
  include Commentable

  after_create :calculate_reputation

  belongs_to :author, class_name: 'User', inverse_of: :authored_questions
  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true
  
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached  :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank
  
  validates :title, :body, presence: true

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
