class RemoveTypeFromQuizzes < ActiveRecord::Migration
  def up
    remove_column :quizzes, :type
  end

  def down
    add_column :quizzes, :type, :string
  end
end
