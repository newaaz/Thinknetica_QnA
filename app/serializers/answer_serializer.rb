class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id author_id body comments links files created_at updated_at]

  def files
    files = []
    
    object.files.each do |file|
      files << { name: file.filename, url: Rails.application.routes.url_helpers.rails_blob_url(file) }
    end

    files
  end
end
