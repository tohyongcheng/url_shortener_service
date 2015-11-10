# A URL Shortener Service
---                                                        

## Overview
A URL Shortening Service that makes use of Ruby, Sinatra and SQLite3
##### required install: ruby, sqlite3

## Quick Start

#### Clone the repo and bundle

    git clone git@github.com:tohyongcheng/url_shortener.git
    cd url_shortener
    bundle install

#### Create the database and run migrate

    rake db:migrate

#### Run tests
    
    rake test

#### Run Sinatra
     
    ruby app.rb

## How to use:

To POST a URL without a slug:

    curl -i -XPOST -d "url=http://www.shopify.com" localhost:4567

To POST a URL with a slug:

    curl -i -XPOST -d "url=http://www.shopify.com&slug=shopify" localhost:4567

To use the URL, just go to the shortened URL in a browser or use curl:

    curl -i -GET localhost:4567/shopify


### Decisions
-   Sinatra - lightweight and easy to configure. We don't need Rails for this for this API-only service.
-   SQLite and ActiveRecord - SQLite is lightweight enough for the application. I used ActiveRecord because it is something that I have been used to, and allows me to use validation callbacks to ensure that the slug and url of the ShortenedURL are valid.
-   Short Slug Generation - I made sure that the slugs generated are of length 8 and consist of only either characters or numbers, e.g `br9igd1j`. Any other character other than will render the slug invalid because you don't want that to affect the URL that is entered.
-   Testing - I made sure to test the controller (Sinatra) actions to render the right responses, as well as the ShortenedURL model to be valid with its inputs for creation. I used Minitest because I wanted to try it out (my first time using instead of Rspec). I figured that using Minitest is more Ruby-ish, which I like better.
