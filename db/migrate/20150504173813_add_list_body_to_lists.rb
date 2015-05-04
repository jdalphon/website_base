class AddListBodyToLists < ActiveRecord::Migration
  def change
    add_column :lists, :body, :text, default: '' 
  end
end
