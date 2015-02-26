class CreateReservationStatusTranslationTable < ActiveRecord::Migration
  def up
    Ref::ReservationStatus.create_translation_table!({ description: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Ref::ReservationStatus.drop_translation_table! migrate_data: true
  end
end
