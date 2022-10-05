class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id author_id title body comments links files created_at updated_at]
  #has_many :answers
  #belongs_to :author

  def files
    files = []
    
    object.files.each do |file|
      files << { name: file.filename, url: Rails.application.routes.url_helpers.rails_blob_url(file) }
    end

    files
  end
end
