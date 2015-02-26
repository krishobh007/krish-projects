class Api::EarlyCheckinSetupsController < ApplicationController
  before_filter :check_session

  #-- Method to list the early checking setup for a hotel --#
  def get_setup
    @early_checkin_rates = current_hotel.early_checkin_rates
    @early_checkin_groups = current_hotel.early_checkin_groups
    @early_checkin_charges = current_hotel.early_checkin_setups.order(:start_time)
  end
  #-- Method to save the early checking setup for a hotel --#
  def save_setup
    errors = []
    ActiveRecord::Base.transaction do
      begin
        current_hotel.settings.is_allow_early_checkin = params[:is_early_checkin_allowed] unless params[:is_early_checkin_allowed].nil?
        current_hotel.settings.early_checkin_charge_code = params[:early_checkin_charge_code] if params[:early_checkin_charge_code]
        current_hotel.settings.max_number_of_early_checkins_per_day = params[:number_of_early_checkins_per_day] if params[:number_of_early_checkins_per_day]
        current_hotel.settings.early_checkin_time = params[:early_checkin_time] if params[:early_checkin_time]
        current_hotel.early_checkin_setups = [] if params[:early_checkin_levels]
        params[:early_checkin_levels].each do |setup_hash|
          current_hotel.early_checkin_setups.create!(charge: setup_hash[:charge], start_time: ActiveSupport::TimeZone[current_hotel.tz_info].parse(setup_hash[:start_time]), addon_id: setup_hash[:addon_id])
        end if params[:early_checkin_levels]
        current_hotel.early_checkin_rates, current_hotel.early_checkin_groups = [], []
        rate_ids = params[:early_checkin_rates].map { |rate| rate[:id] }  if params[:early_checkin_rates]
        current_hotel.early_checkin_rates = current_hotel.rates.find(rate_ids) if params[:early_checkin_rates]
        group_ids = params[:early_checkin_groups].map { |group| group[:id] }  if params[:early_checkin_groups]
        current_hotel.early_checkin_groups = current_hotel.groups.find(group_ids) if params[:early_checkin_groups]
      rescue ActiveRecord::RecordInvalid => ex
        logger.error "*****      Exception occured while trying to save the early checkin setup for hotel #{current_hotel.code}      ***** "
        errors << ex.message
        logger.error "*****    #{ex.message}     ***** "
      end
      fail ActiveRecord::Rollback unless errors.empty?
    end
    render(json: errors, status: :unprocessable_entity) unless errors.empty?
  end
end
