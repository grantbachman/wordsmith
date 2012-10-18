class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string :alpha_value
      t.string :full_value

      t.timestamps
    end
  end
end
