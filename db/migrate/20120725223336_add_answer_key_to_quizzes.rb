class AddAnswerKeyToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :answer_key, :string
  end
end
