class CreateAdminMenuTranslations < ActiveRecord::Migration
  def up
    AdminMenu.create_translation_table!({ name: :string,
                                          description: :string
    }, {
      migrate_data: true
    })
  end

  def down
    AdminMenu.drop_translation_table! migrate_data: true
  end
end
