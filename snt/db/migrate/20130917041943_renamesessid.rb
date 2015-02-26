class Renamesessid < ActiveRecord::Migration
  def up
    rename_column :sessions, :sessid, :session_id
  end

  def down
    rename_column :sessions, :session_id, :sessid
  end
end
