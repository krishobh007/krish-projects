class AddPostingRythmToAddons < ActiveRecord::Migration
  def change
    add_column :addons, :posting_rythm_id, :integer
    add_column :addons, :calculation_rule_id, :integer
    add_column :addons, :is_included_in_rate, :boolean
  end
end
