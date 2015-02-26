class Conversation < ActiveRecord::Base
  attr_accessible :creator_id, :is_group_conversation

  belongs_to :sender, class_name: 'User', foreign_key: 'creator_id'

  has_many :messages , class_name: 'Message', foreign_key: 'conversation_id'


end
