require 'rubygems'
require 'sinatra'
require 'active_record'
require 'json'
require './shortened_url'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'url_shortener.sqlite3'
)

helpers do
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def shortened_url_decorator shortened_url
    { shortened_url: "#{request.host_with_port}/#{shortened_url.slug}", target_url: shortened_url.url }
  end
end

# config for sinatra
set :bind, '0.0.0.0'

# actions
get '/:slug' do
  shortened_url = ShortenedURL.find_by_slug(params[:slug])
  if shortened_url.present?
    redirect shortened_url.url
  else
    halt 404, "No such URL found"
  end
end

post '/' do
  if params[:url] and not params[:url].empty?
    shortened_url = ShortenedURL.new(url: params[:url], slug: params[:slug])
    if shortened_url.save
      shortened_url_decorator(shortened_url).to_json
    else
      halt 403, "Slug has been used before"
    end
  else
    halt 403, "No URL provided"
  end
end