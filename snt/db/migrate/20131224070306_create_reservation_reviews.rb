class CreateReservationReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
     t.references :reservation
     t.string :title
     t.string :description
     t.timestamps
   end
 end
end
