class AddDeletedToWords < ActiveRecord::Migration
  def change
    add_column :words, :deleted, :boolean
  end
end
