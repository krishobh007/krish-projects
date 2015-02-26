json.call(@addon, :name, :description, :amount, :begin_date, :end_date, :amount_type_id, :post_type_id, :charge_group_id, :charge_code_id,
          :rate_code_only, :is_reservation_only, :bestseller)
json.activated @addon.is_active
