class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :authored_answers
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached  :files

  validates :body, :question_id, presence: true
end
