class CreateRefCampaignTypes < ActiveRecord::Migration
  def change
    create_table :ref_campaign_types do |t|
      t.string :value
      t.string :description
      t.timestamps
    end
  end
end
