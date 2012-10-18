class RemoveResponseAndCorrectColumnsFromQuestions < ActiveRecord::Migration
  def up
		remove_column :questions, :response
		remove_column :questions, :correct
  end

  def down
		add_column :questions, :response, :string
		add_column :questions, :correct, :boolean
  end
end
