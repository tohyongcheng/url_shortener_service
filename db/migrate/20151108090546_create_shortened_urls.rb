class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :slug
      t.text :url
      t.timestamps
    end

    add_index :shortened_urls, :slug
  end
end
