class Api::AccountsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :init_account, except: [:index]
  before_filter :init_ar_detail, only: [:ar_details,:ar_notes, :save_ar_note, :save_ar_details]

  def index
    @accounts = current_hotel.hotel_chain.accounts.find_account(params)
  end

  def show

  end

  def save
    begin
      @account.save_account(params)
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def ar_details

  end

  def save_ar_details
    # Generate a random 5 digit ar_number if hotel settings is set as auto_assign_ar_numbers
    if current_hotel.settings.is_auto_assign_ar_numbers && !@ar_detail.ar_number.present?
      existing_ar_numbers = Account.joins(:ar_detail).pluck("ar_details.ar_number").compact
      random_numbers = (10000..99999).to_a - existing_ar_numbers
      params[:ar_number] = random_numbers.sample(1)[0]
    end
    render(json: @ar_detail.errors.full_messages, status: :unprocessable_entity) unless @ar_detail.save_ar_details(params)
  end
  
  def delete_ar_detail
   render(json: ar_note.errors.full_messages, status: :unprocessable_entity) unless @account.ar_detail.delete
  end

  def ar_notes
    @ar_notes = @ar_detail.notes
  end

  def save_ar_note
    save_note = true
    unless @ar_detail.ar_number.present?
      save_note = @ar_detail.update_attributes(ar_number: params[:ar_number])
    end
    if !save_note
      render(json: [t(:ar_number_required)], status: :unprocessable_entity)
    elsif !params[:note].present?
      render(json: [t(:ar_note_required)], status: :unprocessable_entity)
    else
      @note = @ar_detail.notes.create(description: params[:note], note_type: :GENERAL)
    end
  end
  
  def delete_ar_note
   ar_note = @account.ar_detail.notes.find(params[:note_id])
   render(json: ar_note.errors.full_messages, status: :unprocessable_entity) unless ar_note.delete
  end

  private

  def init_account
    @account = params[:id].present? ? current_hotel.hotel_chain.accounts.find(params[:id]) : current_hotel.hotel_chain.accounts.new
  end

  def init_ar_detail
    @ar_detail  = @account.ar_detail.present? ? @account.ar_detail : @account.build_ar_detail
  end

end
