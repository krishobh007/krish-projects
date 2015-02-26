class Note < ActiveRecord::Base
  attr_accessible :note_type, :note_type_id, :description, :external_id

  belongs_to :user, foreign_key: 'updater_id'

  has_enumerated :note_type, class_name: 'Ref::NoteType'
  belongs_to :associated, polymorphic: true
  validates :note_type_id, :description,
            presence: true

  validates :external_id, uniqueness: true, :allow_blank => true, :allow_nil => true

  def sync_note_with_external_pms(reservation)
    result = reservation.modify_notes_of_external_pms('ADD', [{ description: description }])
    errors = []
    if result[:status]
    # Find comment returned from the external PMS that does not exist and has the same description, and then set the external ID
      result[:data].each do |comment|
        if !reservation.notes.exists?(external_id: comment[:external_id]) && comment[:description] == description
          external_id = comment[:external_id]
        end
      end
    else
      errors << I18n.t(:external_pms_failed)
    end
    {result: result, errors: errors}
  end

  def formatted
    date = ApplicationController.helpers.formatted_date(created_at)
    name = user.andand.full_name || ''
    "#{date} #{name}: #{description}"
  end
end
