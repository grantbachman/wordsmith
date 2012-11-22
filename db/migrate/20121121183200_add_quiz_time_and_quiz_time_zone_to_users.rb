class AddQuizTimeAndQuizTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quiz_time, :integer, default: 7
    add_column :users, :quiz_time_zone, :string, default: 'Eastern Time (US & Canada)'
  end
end
