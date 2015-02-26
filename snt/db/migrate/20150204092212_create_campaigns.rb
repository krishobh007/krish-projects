class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :subject
      t.text :body
      t.string :call_to_action_label
      t.string :call_to_action_target
      t.text :alert_ios7
      t.text :alert_ios8
      t.boolean :is_reccuring
      t.date :date_to_send
      t.string :time_to_send
      t.boolean :is_scheduled
      t.date :recurrence_end_date
      t.datetime :last_sent_at
      t.string :status
      t.integer :audience_type_id
      t.integer :campaign_type_id
      t.integer :hotel_id
      t.timestamps
    end
  end
end
