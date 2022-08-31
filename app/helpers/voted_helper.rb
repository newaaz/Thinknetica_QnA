module VotedHelper
  def link_upvote(resource, liked)
    css_class = liked == true ? "enabled" : nil
  
    link_to 'Like', polymorphic_path(resource, action: :upvote),
            method: :patch, class: "link-voute link-upvote #{css_class} me-2",
            remote: true, data: { type: :json }         
  end

  def link_downvote(resource, liked)
    css_class = liked == false ? "enabled" : nil
  
    link_to 'Dislike', polymorphic_path(resource, action: :downvote),
            method: :patch, class: "link-voute link-downvote #{css_class}",
            remote: true, data: { type: :json }         
  end
end
