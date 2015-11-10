class ShortenedURL < ActiveRecord::Base
  before_validation :generate_unique_slug

  validates :slug, presence: true, uniqueness: true
  validates :slug, format: { with: /\A[0-9a-zA-Z]*\z/, message: "has invalid characters" }
  validates :url, presence: true
  validates :url, format: { with: URI.regexp }

  def generate_unique_slug
    if self.slug.nil? or self.slug.empty?
      self.slug = rand(36**8).to_s(36)
    end
  end
end