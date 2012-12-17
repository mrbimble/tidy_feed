class FixPubDateColumnName < ActiveRecord::Migration
  def change
  	rename_column :posts, :pubDate, :pubdate
  end
end
