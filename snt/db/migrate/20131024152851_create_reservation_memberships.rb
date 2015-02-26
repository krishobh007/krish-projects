class CreateReservationMemberships < ActiveRecord::Migration
  def change
    create_table :reservations_memberships, id: false do |t|
      t.references :reservation, null: false
      t.references :membership, null: false
    end
  end
end
