class Message < ActiveRecord::Base
  attr_accessible :conversation_id, :message, :sender_id, :created_at

  belongs_to :sender , class_name: 'User', foreign_key: 'sender_id'
  has_many :messages_recipients, class_name: 'MessagesRecipients', foreign_key: 'message_id'
  has_many :recipients , through: :messages_recipients, class_name: 'User', foreign_key: 'recipient_id'

  belongs_to :conversation

end
