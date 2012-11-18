class AddScoreToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :score, :integer
  end
end
