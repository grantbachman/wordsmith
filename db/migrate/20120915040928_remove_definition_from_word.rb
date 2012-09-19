class RemoveDefinitionFromWord < ActiveRecord::Migration
  def up
		remove_column :words, :definition	
  end

  def down
		add_column :words, :definition, :string
  end
end
