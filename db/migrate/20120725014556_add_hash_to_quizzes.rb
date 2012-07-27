class AddHashToQuizzes < ActiveRecord::Migration
  def up
    add_column :quizzes, :auth_hash, :string
  end

	def down
		remove_column :quizzes, :auth_hash
	end
end
