class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :link
      t.string :guid
      t.string :creator
      t.integer :feed_id
      t.datetime :pubdate
      t.string :content

      t.timestamps
    end

    add_index :posts, [:feed_id, :pubDate]
  end
end
