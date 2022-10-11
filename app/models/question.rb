class Question < ApplicationRecord
  include Votable
  include Commentable

  after_create :calculate_reputation

  belongs_to :author, class_name: 'User', inverse_of: :authored_questions
  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, optional: true

  has_and_belongs_to_many :subscribers, class_name: "User"
  
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached  :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank
  
  validates :title, :body, presence: true

  scope :created_per_day, ->  { select(:id, :title).where(created_at: Time.current.all_day) }
  #scope :created_per_day, ->  { select(:id, :title).where(created_at: (Time.current.midnight - 1.day)..Time.current.midnight) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
