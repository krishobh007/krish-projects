class CreateReservationPreferences < ActiveRecord::Migration
  def change
    create_table :reservations_preferences, id: false do |t|
      t.references :reservation, null: false
      t.references :preference, null: false
    end
  end
end
