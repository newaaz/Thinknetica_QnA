class QuestionsSerializer < ActiveModel::Serializer
  attributes %i[id author_id title body created_at updated_at short_title]
  has_many :answers

  def short_title
    object.title.truncate(5)
  end
end

