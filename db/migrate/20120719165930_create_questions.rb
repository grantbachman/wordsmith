class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :quiz_id
      t.integer :word_id
      t.string :type
      t.string :answer
      t.boolean :correct

      t.timestamps
    end
  end
end
