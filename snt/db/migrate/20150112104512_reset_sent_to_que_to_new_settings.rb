class ResetSentToQueToNewSettings < ActiveRecord::Migration
  def up
    Hotel.all.each do |hotel|
      if hotel.settings.is_sent_to_queue == true
        hotel.settings.checkin_action = "sent_to_queue"
      end
    end
  end
end
