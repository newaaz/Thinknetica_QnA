class AnswersSerializer < ActiveModel::Serializer
  attributes %i[id author_id body created_at updated_at]
end
