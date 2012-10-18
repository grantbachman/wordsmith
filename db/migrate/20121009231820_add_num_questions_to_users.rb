class AddNumQuestionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_quiz_questions, :integer, default: 7
  end
end
