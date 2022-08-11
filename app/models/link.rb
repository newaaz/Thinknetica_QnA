require 'open-uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: /\A#{URI::regexp(['http', 'https'])}\z/, message: "Invalid url" }
  validate  :check_url

  private

  def check_url
    errors.add(:url, "This page does not exist") if open(self.url).status != ["200", "OK"]
  rescue StandardError => e
    errors.add(:url, "This page does not exist")
  end
end

