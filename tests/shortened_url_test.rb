require File.expand_path '../test_helper.rb', __FILE__
include Rack::Test::Methods

def app
  Sinatra::Application
end

class ShortenedURLTest < Minitest::Test
  def setup
    @su = ShortenedURL.create(slug: "123", url: "https://www.google.com")
  end

  def teardown
    ShortenedURL.delete_all
  end

  def test_shortened_url
    assert_respond_to @su, :url
    assert_respond_to @su, :slug
  end

  def test_create
    new_su = ShortenedURL.create(slug: "456", url: "http://www.shopify.com")
    assert_instance_of ShortenedURL, new_su
    assert_equal new_su.slug, "456"
    assert_equal new_su.url, "http://www.shopify.com"
  end

  def test_create_without_slug
    new_su = ShortenedURL.create(url: "http://www.shopify.com")
    assert_equal new_su.url, "http://www.shopify.com"
    refute_nil new_su.slug
  end

  def test_create_without_url
    new_su = ShortenedURL.create(slug: "somethingunique")
    assert new_su.invalid?
  end

  def test_create_with_non_unique_slug
    new_su = ShortenedURL.create(slug: "123", url:"http://www.shopify.com")
    assert new_su.invalid?
  end

  def test_create_with_weird_slug
    new_su = ShortenedURL.create(slug: "!123&", url:"http://www.shopify.com")
    assert new_su.invalid?
  end
end