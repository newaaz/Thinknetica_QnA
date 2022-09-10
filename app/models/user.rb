class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many  :authored_questions, foreign_key: "author_id", class_name: "Question", inverse_of: :author, dependent: :destroy
  has_many  :authored_answers, foreign_key: "author_id", class_name: "Answer", inverse_of: :author, dependent: :destroy
  has_many  :awards
  has_many  :votes, dependent: :destroy
  has_many  :comments, dependent: :destroy

  def author?(resource)
    self == resource.author
  end
end
