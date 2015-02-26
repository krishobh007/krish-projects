json.is_snt_admin @is_snt_admin

if @is_snt_admin
  json.product_cross_customer do
    json.tracker_guest_web @product_cross_customer.zest_web.andand.tracking_id
    json.tracker_zest_ios @product_cross_customer.zest_ios.andand.tracking_id
    json.tracker_zest_android @product_cross_customer.zest_android.andand.tracking_id
  end
else
  json.product_customer do
    json.tracker_guest_web @product_customer.zest_web.andand.tracking_id.to_s
    json.tracker_zest_ios @product_customer.zest_ios.andand.tracking_id.to_s
    json.tracker_zest_android @product_customer.zest_android.andand.tracking_id.to_s
  end
  json.product_customer_proprietary do
    json.tracker_guest_web @product_customer_proprietary.zest_web.andand.tracking_id.to_s
    json.tracker_zest_ios @product_customer_proprietary.zest_ios.andand.tracking_id.to_s
    json.tracker_zest_android @product_customer_proprietary.zest_android.andand.tracking_id.to_s
    json.selected_tracker @selected_tracker_id
  end

  json.available_trackers @available_trackers do |tracker|
    json.value tracker.id
    json.name tracker.description
  end
end