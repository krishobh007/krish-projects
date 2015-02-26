class AnalyticsSetup < ActiveRecord::Base
  attr_accessible :analytics_type, :product_type, :product_type, :tracking_id, :service_id
  has_enumerated :service, :class_name => 'Ref::AnalyticsService'

  scope :product_cross_customer, -> {where(analytics_type: Setting.anaytics_types[:product_cross_customer])}
  scope :product_customer, -> {where(analytics_type: Setting.anaytics_types[:product_customer])}
  scope :product_customer_proprietary, -> {where(analytics_type: Setting.anaytics_types[:product_customer_proprietary])}
  
  scope :zest_web_setups, -> {where(product_type: Setting.anaytics_product_types[:zest_web])}
  scope :zest_app_ios_setups, -> {where(product_type: Setting.anaytics_product_types[:zest_app_ios])}
  scope :zest_app_android_setups, -> {where(product_type: Setting.anaytics_product_types[:zest_app_android])}


  def self.zest_web
   	zest_web_setups.first
  end

  def self.zest_ios
   	zest_app_ios_setups.first
  end

  def self.zest_android
   	zest_app_android_setups.first
  end

end
