class CreateAdminMenuOptionTranslations < ActiveRecord::Migration
  def up
    AdminMenuOption.create_translation_table!({ name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    AdminMenuOption.drop_translation_table! migrate_data: true
  end
end
