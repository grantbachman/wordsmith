class AddLevelToWords < ActiveRecord::Migration
  def change
    add_column :words, :level, :integer, default: 1
  end
end
