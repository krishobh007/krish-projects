class RemovePromotionalRateType < ActiveRecord::Migration
  def change
    execute('update rates set rate_type_id = (select id from rate_types where name = "Specials & Promotions")
            where rate_type_id = (select id from rate_types where name = "Promotional")')
    execute('delete from rate_types where name = "Promotional"')
  end
end
