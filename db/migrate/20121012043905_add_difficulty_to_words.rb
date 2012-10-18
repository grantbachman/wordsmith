class AddDifficultyToWords < ActiveRecord::Migration
  def change
    add_column :words, :difficulty, :integer, default: 1
  end
end
