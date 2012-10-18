class RemoveStyleFromQuestions < ActiveRecord::Migration
  def up
		remove_column :questions, :style
  end

  def down
		add_colum :questions, :style, :string
  end
end
