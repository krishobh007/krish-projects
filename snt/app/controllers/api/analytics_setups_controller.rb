class Api::AnalyticsSetupsController < ApplicationController
  before_filter :check_session

  def index
  	@is_snt_admin = current_user.admin?
  	if @is_snt_admin
  	  @product_cross_customer = AnalyticsSetup.product_cross_customer
    else
      @product_customer = current_hotel.analytics_setups.product_customer
      @product_customer_proprietary = current_hotel.analytics_setups.product_customer_proprietary
      @available_trackers = Ref::AnalyticsService.all
      @selected_tracker_id = current_hotel.analytics_setups.product_customer_proprietary.first.andand.service_id
    end
  end

  def save_setup
  	@is_snt_admin = current_user.admin?
  	if @is_snt_admin
  	  if params[:product_cross_customer].present?
        product_cross_customer = AnalyticsSetup.product_cross_customer
        if product_cross_customer.present?
          product_cross_customer.zest_web.update_attributes(tracking_id: params[:product_cross_customer][:tracker_guest_web])
          product_cross_customer.zest_ios.update_attributes(tracking_id: params[:product_cross_customer][:tracker_zest_ios])
          product_cross_customer.zest_android.update_attributes(tracking_id: params[:product_cross_customer][:tracker_zest_android])
        else
          AnalyticsSetup.create!(tracking_id: params[:product_cross_customer][:tracker_guest_web], analytics_type: Setting.anaytics_types[:product_cross_customer], product_type: Setting.anaytics_product_types[:zest_web])
          AnalyticsSetup.create!(tracking_id: params[:product_cross_customer][:tracker_zest_ios], analytics_type: Setting.anaytics_types[:product_cross_customer], product_type: Setting.anaytics_product_types[:zest_app_ios])
          AnalyticsSetup.create!(tracking_id: params[:product_cross_customer][:tracker_zest_android], analytics_type: Setting.anaytics_types[:product_cross_customer], product_type: Setting.anaytics_product_types[:zest_app_android])
        end
      end
    else
      if params[:product_customer].present?
        product_customer = AnalyticsSetup.product_customer
        if product_customer.present?
          product_customer.zest_web.update_attributes(tracking_id: params[:product_customer][:tracker_guest_web])
          product_customer.zest_ios.update_attributes(tracking_id: params[:product_customer][:tracker_zest_ios])
          product_customer.zest_android.update_attributes(tracking_id: params[:product_customer][:tracker_zest_android])
        else
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer][:tracker_guest_web], analytics_type: Setting.anaytics_types[:product_customer], product_type: Setting.anaytics_product_types[:zest_web])
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer][:tracker_zest_ios], analytics_type: Setting.anaytics_types[:product_customer], product_type: Setting.anaytics_product_types[:zest_app_ios])
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer][:tracker_zest_android], analytics_type: Setting.anaytics_types[:product_customer], product_type: Setting.anaytics_product_types[:zest_app_android])
        end
      end
      if params[:product_customer_proprietary].present?
        selected_tracker = Ref::AnalyticsService.find_by_id(params[:product_customer_proprietary][:selected_tracker]) if params[:product_customer_proprietary][:selected_tracker]
        product_customer_proprietary = current_hotel.analytics_setups.product_customer_proprietary
        if product_customer_proprietary.present?
          product_customer_proprietary.zest_web.update_attributes(tracking_id: params[:product_customer_proprietary][:tracker_guest_web], service_id: selected_tracker.andand.id)
          product_customer_proprietary.zest_ios.update_attributes(tracking_id: params[:product_customer_proprietary][:tracker_zest_ios], service_id: selected_tracker.andand.id)
          product_customer_proprietary.zest_android.update_attributes(tracking_id: params[:product_customer_proprietary][:tracker_zest_android], service_id: selected_tracker.andand.id)
        else
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer_proprietary][:tracker_guest_web], analytics_type: Setting.anaytics_types[:product_customer_proprietary], product_type: Setting.anaytics_product_types[:zest_web], service_id: selected_tracker.andand.id)
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer_proprietary][:tracker_zest_ios], analytics_type: Setting.anaytics_types[:product_customer_proprietary], product_type: Setting.anaytics_product_types[:zest_app_ios], service_id: selected_tracker.andand.id)
          current_hotel.analytics_setups.create(tracking_id: params[:product_customer_proprietary][:tracker_zest_android], analytics_type: Setting.anaytics_types[:product_customer_proprietary], product_type: Setting.anaytics_product_types[:zest_app_android], service_id: selected_tracker.andand.id)
        end
      end
    end
  end


end