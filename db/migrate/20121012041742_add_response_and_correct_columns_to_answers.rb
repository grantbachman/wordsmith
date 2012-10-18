class AddResponseAndCorrectColumnsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :response, :string
    add_column :answers, :correct, :boolean
  end
end
