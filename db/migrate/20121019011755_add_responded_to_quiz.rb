class AddRespondedToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :responded, :boolean, default: false
  end
end
