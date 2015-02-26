class AddTimestampToSignature < ActiveRecord::Migration
  def change
    add_timestamps(:reservation_signatures)
  end
end
