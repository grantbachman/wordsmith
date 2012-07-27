class ChangeColumnNameOfQuestions < ActiveRecord::Migration
  def up
		rename_column :questions, :type, :style
  end

  def down
		rename_column :questions, :style, :type
  end
end
