class RenameIsVideoCheckoutDisabled < ActiveRecord::Migration
  def change
    rename_column :reservations, :is_video_checkout_disabled, :is_remote_co_allowed
  end
end
