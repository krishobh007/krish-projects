class CreateRefRestrictionTypes < ActiveRecord::Migration
  def change
    create_table :ref_restriction_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :hotels_restriction_types do |t|
      t.references :hotel
      t.references :restriction_type
    end
  end
end
