class ChangeAttendenceUserToTeam < ActiveRecord::Migration
  def change
    remove_column :attendances, :user_id
    add_column :attendances, :team_id, :integer
  end
end
