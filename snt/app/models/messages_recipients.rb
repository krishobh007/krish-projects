class MessagesRecipients < ActiveRecord::Base
   attr_accessible :recipient_id, :message_id, :is_read, :is_pushed

   belongs_to :recipient, class_name: 'User'
   belongs_to :received_message , class_name: 'Message', foreign_key: 'message_id'

end
