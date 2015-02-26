class DropPreferenceIdFromUserPreferences < ActiveRecord::Migration
  def change
    remove_column :user_preferences, :preference_id
  end
end
