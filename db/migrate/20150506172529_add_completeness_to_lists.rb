class AddCompletenessToLists < ActiveRecord::Migration
  def change
    add_column :lists, :completeness, :float, :default => 0
  end
end
