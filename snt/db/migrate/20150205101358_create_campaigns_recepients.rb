class CreateCampaignsRecepients < ActiveRecord::Migration
  def change
    create_table :campaigns_recepients do |t|
      t.integer :campaign_id
      t.integer :guest_detail_id
      t.timestamps
    end
  end
end
