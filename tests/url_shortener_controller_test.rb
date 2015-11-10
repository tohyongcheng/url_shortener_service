require File.expand_path '../test_helper.rb', __FILE__
include Rack::Test::Methods

def app
  Sinatra::Application
end

class URLShortenerControllerTest < Minitest::Test
  def setup
    @su = ShortenedURL.create(slug: "123", url: "https://www.google.com")
    @url1 = "http://www.shopify.com"
    @url2 = "http://www.amazon.com"
    @slug2 = "amazon"
  end

  def teardown
    ShortenedURL.delete_all
  end

  def test_get_with_valid_slug
    get '/123'
    assert_equal last_response.status, 302
    assert_equal last_response.location, @su.url
  end

  def test_get_with_nonexisting_slug
    get '/456'
    assert_equal last_response.status, 404
  end

  def test_get_without_slug
    get '/'
    assert_equal last_response.status, 404
  end

  def test_post_without_url
    post '/'
    assert_equal last_response.status, 403
    assert_includes last_response.body, "No URL provided"
  end

  def test_post_with_url_without_slug
    post '/', { url: @url1 } 
    assert_equal last_response.status, 200
    assert_includes last_response.body, @url1
  end

  def test_post_with_url_and_unique_slug
    post '/', { url: @url2, slug: @slug2 }
    assert_equal last_response.status, 200
    assert_includes last_response.body, @url2
    assert_includes last_response.body, @slug2
  end

  def test_post_with_url_and_non_unique_slug
    post '/', { url: "http://www.facebook.com", slug: "123" }
    assert_equal last_response.status, 403
    assert_includes last_response.body, "Slug has been used before"
  end
end