class ChangeColumnTypeForContentToText < ActiveRecord::Migration
  change_table :posts do |t|
  	t.change :content, :text
  end
end
