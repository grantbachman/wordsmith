class AddWordBankToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :word_bank, :string
  end
end
