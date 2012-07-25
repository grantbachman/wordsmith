class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :user_id
			t.string :type
      t.timestamps
    end
  end
end
