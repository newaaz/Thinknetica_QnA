class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def purge    
    @attachment = ActiveStorage::Attachment.find(params[:id])    
    @attachment.purge if current_user.author?(@attachment.record)    
  end
end

