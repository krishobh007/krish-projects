class AddKeySystemEncoderEnabled < ActiveRecord::Migration
  def change
    add_column :ref_key_systems, :encoder_enabled, :boolean, null: false, default: false
  end
end
