#coding: utf-8
module SeedReferenceValues
  def create_reference_values
    Ref::ContactType.enumeration_model_updates_permitted = true
    Ref::ContactType.create(value: 'EMAIL', description: 'Email')
    Ref::ContactType.create(value: 'PHONE', description: 'Phone')
    Ref::ContactType.create(value: 'FAX', description: 'Fax')

    Ref::ContactLabel.enumeration_model_updates_permitted = true
    Ref::ContactLabel.create(value: 'HOME', description: 'Home')
    Ref::ContactLabel.create(value: 'BUSINESS', description: 'Business')
    Ref::ContactLabel.create(value: 'MOBILE', description: 'Mobile')

    # Credit Card Types
    Ref::CreditCardType.enumeration_model_updates_permitted = true
    Ref::CreditCardType.create(value: 'VA', description: 'Visa', validator_code: 'visa')
    Ref::CreditCardType.create(value: 'MC', description: 'Master Card', validator_code: 'master_card')
    Ref::CreditCardType.create(value: 'DC', description: 'Diners Club', validator_code: 'diners_club')
    Ref::CreditCardType.create(value: 'DS', description: 'Discover', validator_code: 'discover')
    Ref::CreditCardType.create(value: 'JCB', description: 'Japan Credit Bureau', validator_code: 'jcb')
    Ref::CreditCardType.create(value: 'AX', description: 'American Express', validator_code: 'amex')
    Ref::CreditCardType.create(value: 'UM', description: 'UK Maestro', validator_code: 'uk_maestro')

    Ref::MembershipClass.enumeration_model_updates_permitted = true
    Ref::MembershipClass.create(value: 'FFP', description: 'Frequent Flyer Program', is_system_only: true)
    Ref::MembershipClass.create(value: 'HLP', description: 'Hotel Loyalty Program', is_system_only: true)

    # Note types
    Ref::NoteType.enumeration_model_updates_permitted = true
    Ref::NoteType.create(value: 'GENERAL', description: 'General')

    # Reservation statuses
    Ref::ReservationStatus.enumeration_model_updates_permitted = true
    Ref::ReservationStatus.create(value: 'RESERVED')
    Ref::ReservationStatus.create(value: 'CHECKEDIN')
    Ref::ReservationStatus.create(value: 'CHECKEDOUT')
    Ref::ReservationStatus.create(value: 'NOSHOW')
    Ref::ReservationStatus.create(value: 'CANCELED')
    Ref::ReservationStatus.create(value: 'PRE_CHECKIN')

    I18n.locale = :en

    Ref::ReservationStatus.update_enumerations_model do
      Ref::ReservationStatus[:RESERVED].update_attribute(:description, "Reserved")
    end
    Ref::ReservationStatus.update_enumerations_model do
      Ref::ReservationStatus[:CHECKEDIN].update_attribute(:description, "Checked In")
    end
    Ref::ReservationStatus.update_enumerations_model do
      Ref::ReservationStatus[:CHECKEDOUT].update_attribute(:description, "Checked Out")
    end
    Ref::ReservationStatus.update_enumerations_model do
      Ref::ReservationStatus[:NOSHOW].update_attribute(:description, "No Show")
    end
    Ref::ReservationStatus.update_enumerations_model do
      Ref::ReservationStatus[:CANCELED].update_attribute(:description, "Canceled")
    end

    # FO Status (Front office statuses)
    Ref::FrontOfficeStatus.enumeration_model_updates_permitted = true
    Ref::FrontOfficeStatus.create(value: 'VACANT', description: 'Vacant')
    Ref::FrontOfficeStatus.create(value: 'OCCUPIED', description: 'Occupied')

    # HK status (House keeping statuses)
    Ref::HousekeepingStatus.enumeration_model_updates_permitted = true
    Ref::HousekeepingStatus.create(value: 'CLEAN', description: 'Clean')
    Ref::HousekeepingStatus.create(value: 'INSPECTED', description: 'Inspected')
    Ref::HousekeepingStatus.create(value: 'DIRTY', description: 'Dirty')
    Ref::HousekeepingStatus.create(value: 'OS', description: 'Out Of Service')
    Ref::HousekeepingStatus.create(value: 'OO', description: 'Out Of Order')
    Ref::HousekeepingStatus.create(value: 'PICKUP', description: 'Pickup')

    # Add-On Categories
    Ref::Addon.enumeration_model_updates_permitted = true
    Ref::Addon.create(value: 'BESTSELLER', description: 'Bestsellers')
    Ref::Addon.create(value: 'FNB', description: 'Food & Beverage')
    Ref::Addon.create(value: 'SPA', description: 'Spa')
    Ref::Addon.create(value: 'TRANSPORTATION', description: 'Transportation')
    Ref::Addon.create(value: 'ATTRACTIONS', description: 'Attractions')
    Ref::Addon.create(value: 'BEDDING', description: 'Bedding')
    Ref::Addon.create(value: 'PARKING', description: 'Golf')

    # Cancellation Codes
    Ref::CancelCode.enumeration_model_updates_permitted = true
    Ref::CancelCode.create(value: 'PLANCHANGE', description: 'Change of Plans')

    # Languages
    Ref::Language.enumeration_model_updates_permitted = true
    Ref::Language.create(value: 'EN', description: 'English')
    Ref::Language.create(value: 'DE', description: 'German')
    Ref::Language.create(value: 'FR', description: 'French')
    Ref::Language.create(value: 'ES', description: 'Spanish')
    Ref::Language.create(value: 'JA', description: 'Japanese')
    Ref::Language.create(value: 'ZH', description: 'Chinese')

    # Titles
    Ref::Title.enumeration_model_updates_permitted = true
    Ref::Title.create(value: 'Mr', description: 'Mr')
    Ref::Title.create(value: 'Mrs', description: 'Mrs')
    Ref::Title.create(value: 'Ms', description: 'Ms')
    Ref::Title.create(value: 'Miss', description: 'Miss')
    Ref::Title.create(value: 'Dr', description: 'Dr')
    Ref::Title.create(value: 'Prof', description: 'Professor')

    # Wakeup statuses
    Ref::WakeupStatus.enumeration_model_updates_permitted = true
    Ref::WakeupStatus.create(value: 'REQUESTED', description: 'Wakeup Requested')
    Ref::WakeupStatus.create(value: 'PROCESSED', description: 'Wakeup Processed')
    Ref::WakeupStatus.create(value: 'CANCEL', description: 'Wakeup Canceled')

    # Discount types
    Ref::DiscountType.enumeration_model_updates_permitted = true
    Ref::DiscountType.create(value: 'DISCOUNTAMOUNT', description: 'Discount Amount')
    Ref::DiscountType.create(value: 'DISCOUNTPERCENT', description: 'Discount Percent')

    # Policy types
    Ref::PolicyType.enumeration_model_updates_permitted = true
    Ref::PolicyType.create(value: 'DEPOSIT_REQUEST', description: 'Deposit Request')
    Ref::PolicyType.create(value: 'CANCELLATION_POLICY', description: 'Cancellation Policy')

    # Account types
    Ref::AccountType.enumeration_model_updates_permitted = true
    Ref::AccountType.create(value: 'COMPANY', description: 'Company')
    Ref::AccountType.create(value: 'TRAVELAGENT', description: 'Travel Agent')

    # PMS Types
    Ref::PmsType.enumeration_model_updates_permitted = true
    Ref::PmsType.create(value: 'OWS', description: 'Opera Web Service')

    # Currency Codes
    Ref::CurrencyCode.enumeration_model_updates_permitted = true
    Ref::CurrencyCode.create(value: 'USD', description: 'United States Dollar', symbol: '$')
    Ref::CurrencyCode.create(value: 'EUR', description: 'Euro', symbol: '€')
    Ref::CurrencyCode.create(value: 'GBP', description: 'British Pound', symbol: '£')
    # Charge Code Types
    Ref::ChargeCodeType.enumeration_model_updates_permitted = true

    Ref::ChargeCodeType.create(value: 'TAX', description: 'TAX')
    Ref::ChargeCodeType.create(value: 'PAYMENT', description: 'PAYMENT')
    Ref::ChargeCodeType.create(value: 'ADDON', description: 'ADDON')
    Ref::ChargeCodeType.create(value: 'OTHERS', description: 'OTHERS')
    Ref::ChargeCodeType.create(value: 'ROOM', description: 'ROOM')
    Ref::ChargeCodeType.create(value: 'FEES', description: 'FEES')

    # Key Card Types
    Ref::KeyCardType.enumeration_model_updates_permitted = true
    Ref::KeyCardType.create(value: 'CLASSIC', description: 'Mifare Classic')
    Ref::KeyCardType.create(value: 'MINI', description: 'Mifare Mini')
    Ref::KeyCardType.create(value: 'ULTRALIGHT', description: 'Mifare Ultralight')
    Ref::KeyCardType.create(value: 'TAGIT', description: 'Tagit')

    # Key Systems
    Ref::KeySystem.enumeration_model_updates_permitted = true
    Ref::KeySystem.create(value: 'VINGCARD', description: 'Vingcard Key System', key_card_type: :CLASSIC, aid: '7009', keyb: nil)
    Ref::KeySystem.create(value: 'SAFLOK', description: 'Saflok Key System', key_card_type: :CLASSIC, retrieve_uid: true)
    Ref::KeySystem.create(value: 'SAFLOK_MSR', description: 'Saflok MSR Key System', key_card_type: :CLASSIC, encoder_enabled: true)
    Ref::KeySystem.create(value: 'SALTO', description: 'Salto Key System', key_card_type: :TAGIT, retrieve_uid: true)

    # Posting Rythms
    Ref::PostingRythm.enumeration_model_updates_permitted = true
    Ref::PostingRythm.create(value: 'D', description: 'Post every night')
    Ref::PostingRythm.create(value: 'F', description: 'Post every night except first night')
    Ref::PostingRythm.create(value: 'L', description: 'Post every night except last night')
    Ref::PostingRythm.create(value: 'A', description: 'Post on arrival night')

    # Calculation Rules
    Ref::CalculationRule.enumeration_model_updates_permitted = true
    Ref::CalculationRule.create(value: 'F', description: 'Flat Rate')
    Ref::CalculationRule.create(value: 'C', description: 'Per Adult')
    Ref::CalculationRule.create(value: 'A', description: 'Per Child')
    Ref::CalculationRule.create(value: 'P', description: 'Per Person')
    Ref::CalculationRule.create(value: 'R', description: 'Per Room')

    # Applications
    Ref::Application.enumeration_model_updates_permitted = true
    Ref::Application.create(value: 'ROVER', description: 'Rover')
    Ref::Application.create(value: 'WEB', description: 'Web')
    Ref::Application.create(value: 'ZEST', description: 'Zest')

    # Action Types
    Ref::ActionType.enumeration_model_updates_permitted = true
    Ref::ActionType.create(value: 'CHECKEDIN', description: 'Checked In')
    Ref::ActionType.create(value: 'CHECKEDOUT', description: 'Checked Out')
    Ref::ActionType.create(value: 'UPSELL', description: 'Upsell')
    Ref::ActionType.create(value: 'LATECHECKOUT', description: 'Late Checkout')
    Ref::ActionType.create(value: 'EMAIL_CHECKIN', description: 'Check In Email Sent')
    Ref::ActionType.create(value: 'EMAIL_CHECKOUT', description: 'Check Out Email Sent')
    Ref::ActionType.create(value: 'DELETE_TRANSACTION', description: 'Financial Transaction Deleted')
    Ref::ActionType.create(value: 'EDIT_TRANSACTION', description: 'Financial Transaction Edited')
    Ref::ActionType.create(value: 'SPLIT_TRANSACTION', description: 'Financial Transaction Splitted')
    Ref::ActionType.create(value: 'CREATE_TRANSACTION', description: 'Financial Transaction Created')
    Ref::ActionType.create(value: 'CREATE_CC_TRANSACTION', description: 'Credit Card Transaction Created')
    Ref::ActionType.create(value: 'UPDATE_CC_TRANSACTION', description: 'Credit Card Transaction Updated')
    Ref::ActionType.create(value: 'LOGIN', description: 'Login')
    Ref::ActionType.create(value: 'LOGOUT', description: 'Logout')
    Ref::ActionType.create(value: 'INVALID_LOGIN', description: 'Invalid Login')
    # Amount Types
    Ref::AmountType.enumeration_model_updates_permitted = true
    Ref::AmountType.create(value: 'ADULT', description: 'Adult')
    Ref::AmountType.create(value: 'CHILD', description: 'Child')
    Ref::AmountType.create(value: 'PERSON', description: 'Person')
    Ref::AmountType.create(value: 'FLAT', description: 'Flat')

     # Post Types
    Ref::PostType.enumeration_model_updates_permitted = true
    Ref::PostType.create(value: 'STAY', description: 'Entire Stay')
    Ref::PostType.create(value: 'NIGHT', description: 'First Night')

    # Restriction Types
    Ref::RestrictionType.enumeration_model_updates_permitted = true
    Ref::RestrictionType.create(value: 'CLOSED', description: 'Closed')
    Ref::RestrictionType.create(value: 'CLOSED_ARRIVAL', description: 'Closed to Arrival')
    Ref::RestrictionType.create(value: 'CLOSED_DEPARTURE', description: 'Closed to Departure')
    Ref::RestrictionType.create(value: 'MIN_STAY_LENGTH', description: 'Min Length of Stay')
    Ref::RestrictionType.create(value: 'MAX_STAY_LENGTH', description: 'Max Length of Stay')
    Ref::RestrictionType.create(value: 'MIN_STAY_THROUGH', description: 'Min Stay Through')
    Ref::RestrictionType.create(value: 'MIN_ADV_BOOKING', description: 'Min Advance Booking')
    Ref::RestrictionType.create(value: 'MAX_ADV_BOOKING', description: 'Max Advance Booking')
    Ref::RestrictionType.create(value: 'DEPOSIT_REQUESTED', description: 'Deposit Requests', editable: true)
    Ref::RestrictionType.create(value: 'CANCEL_PENALTIES', description: 'Cancellation Penalties', editable: true)
    Ref::RestrictionType.create(value: 'LEVELS', description: 'Levels', editable: true)

    # Filters for the Reports Module
    Ref::ReportFilter.enumeration_model_updates_permitted = true
    Ref::ReportFilter.create(value: 'DATE_RANGE', description: 'Date Range')
    Ref::ReportFilter.create(value: 'TIME_RANGE', description: 'Time Range')
    Ref::ReportFilter.create(value: 'CICO', description: 'Check In / Check Out')
    Ref::ReportFilter.create(value: 'USER', description: 'Staff Name')
    Ref::ReportFilter.create(value: 'INCLUDE_NOTES', description: 'Include Notes')
    Ref::ReportFilter.create(value: 'VIP_ONLY', description: 'VIP Only')
    Ref::ReportFilter.create(value: 'INCLUDE_CANCELED', description: 'Include Canceled')
    Ref::ReportFilter.create(value: 'INCLUDE_NO_SHOW', description: 'Include No Show')
    Ref::ReportFilter.create(value: 'CANCELATION_DATE_RANGE', description: 'Cancelation Date Range')
    Ref::ReportFilter.create(value: 'INCLUDE_MARKET', description: 'Include Market')
    Ref::ReportFilter.create(value: 'INCLUDE_SOURCE', description: 'Include Source')
    Ref::ReportFilter.create(value: 'ARRIVAL_DATE_RANGE', description: 'Arrival Date Range')
    Ref::ReportFilter.create(value: 'INCLUDE_LAST_YEAR', description: 'Include Last Year')
    Ref::ReportFilter.create(value: 'INCLUDE_VARIANCE', description: 'Include Variance')
    Ref::ReportFilter.create(value: 'INCLUDE_COMPANYCARD_TA_GROUP', description: 'Include Company Card/TA/Group')
    Ref::ReportFilter.create(value: 'INCLUDE_GUARANTEE_TYPE', description: 'Include Guarantee Type')

    Ref::ReportFilter.create(value: 'ZEST', description: 'Zest')
    Ref::ReportFilter.create(value: 'ZEST_WEB', description: 'Zest Web')
    Ref::ReportFilter.create(value: 'ROVER', description: 'Rover')
    Ref::ReportFilter.create(value: 'SHOW_GUESTS', description: 'Show Guests')

    

    Ref::ReportFilter.create(value: 'DEPOSIT_PAID', description: 'Deposit Paid')
    Ref::ReportFilter.create(value: 'DEPOSIT_DUE', description: 'Deposit Due')
    Ref::ReportFilter.create(value: 'DEPOSIT_DATE_RANGE', description: 'Deposit due date range')
    Ref::ReportFilter.create(value: 'DEPOSIT_PAST', description: 'Deposit past')

    # Sortable Fields for the Reports Module
    Ref::ReportSortableField.enumeration_model_updates_permitted = true
    Ref::ReportSortableField.create(value: 'DATE', description: 'Date')
    Ref::ReportSortableField.create(value: 'USER', description: 'User')
    Ref::ReportSortableField.create(value: 'ROOM', description: 'Room')
    Ref::ReportSortableField.create(value: 'NAME', description: 'Name')
    Ref::ReportSortableField.create(value: 'RESERVATION', description: 'Reservation Number')
    Ref::ReportSortableField.create(value: 'PAID_DATE_RANGE', description: 'Deposit Paid Date')
    Ref::ReportSortableField.create(value: 'DUE_DATE_RANGE', description: 'Deposit Due Date')

    Ref::Dashboard.enumeration_model_updates_permitted = true
    Ref::Dashboard.create(value: 'MANAGER', description: 'Manager')
    Ref::Dashboard.create(value: 'FRONT_DESK', description: 'Front Desk')
    Ref::Dashboard.create(value: 'HOUSEKEEPING', description: 'Housekeeping')

    # Ref values for reservation types
    Ref::ReservationType.enumeration_model_updates_permitted = true
    Ref::ReservationType.create(value: '4PM_HOLD', description: '4pm Hold')
    Ref::ReservationType.create(value: '6PM_HOLD', description: '6pm Hold')
    Ref::ReservationType.create(value: 'CREDIT_CARD_GUARANTEED', description: 'Credit Card Guaranteed')
    Ref::ReservationType.create(value: 'DEPOSIT_REQUESTED', description: 'Deposit Requested')
    Ref::ReservationType.create(value: 'DEPOSIT_RECEIVED', description: 'Deposit Received')
    Ref::ReservationType.create(value: 'COMPANY_GUARENTEED', description: 'Company Guaranteed')
    Ref::ReservationType.create(value: 'TRAVEL_AGENT_GUARANTEED', description: 'Travel Agent Guaranteed')
    Ref::ReservationType.create(value: 'NOT_GUARANTEED', description: 'Not Guaranteed')
    Ref::ReservationType.create(value: 'HOUSE_USE', description: 'House Use')

    # Ref values for beacon ranges
    Ref::BeaconRange.enumeration_model_updates_permitted = true
    Ref::BeaconRange.create(value: 'FAR', description: 'Far')
    Ref::BeaconRange.create(value: 'NEAR', description: 'Near')
    Ref::BeaconRange.create(value: 'IMMEDIATE', description: 'Immediate')

    # Ref values for beacon types
    Ref::BeaconType.enumeration_model_updates_permitted = true
    Ref::BeaconType.create(value: 'CHECKIN', description: 'Check in')
    Ref::BeaconType.create(value: 'CHECKOUT', description: 'Check out')
    Ref::BeaconType.create(value: 'PROMOTION', description: 'Promotion')

    # Reference values for date formats
    Ref::DateFormat.enumeration_model_updates_permitted = true
    Ref::DateFormat.create(value: 'DD-MM-YYYY', description: 'DD-MM-YYYY')
    Ref::DateFormat.create(value: 'DD/MM/YYYY', description: 'DD/MM/YYYY')
    Ref::DateFormat.create(value: 'MM-DD-YYYY', description: 'MM-DD-YYYY')
    Ref::DateFormat.create(value: 'MM/DD/YYYY', description: 'MM/DD/YYYY')

    # Reference values for reservation house keeping statuses
    Ref::ReservationHkStatus.enumeration_model_updates_permitted = true
    Ref::ReservationHkStatus.create(value: 'ARRIVALS', description: 'Arrivals')
    Ref::ReservationHkStatus.create(value: 'DEPARTED', description: 'Departed')
    Ref::ReservationHkStatus.create(value: 'ARRIVED', description: 'Arrived')
    Ref::ReservationHkStatus.create(value: 'STAYOVER', description: 'Stayover')
    Ref::ReservationHkStatus.create(value: 'DUEOUT', description: 'Dueout')
    Ref::ReservationHkStatus.create(value: 'NOT_RESERVED', description: 'Not Reserved')

    # Reference values for service statuses
    Ref::ServiceStatus.enumeration_model_updates_permitted = true
    Ref::ServiceStatus.create(value: 'IN_SERVICE', description: 'In Service')
    Ref::ServiceStatus.create(value: 'OUT_OF_SERVICE', description: 'Out Of Service')
    Ref::ServiceStatus.create(value: 'OUT_OF_ORDER', description: 'Out Of Order')

    # Reference values for work statuses
    Ref::WorkStatus.enumeration_model_updates_permitted = true
    Ref::WorkStatus.create(value: 'OPEN', description: 'Open')
    Ref::WorkStatus.create(value: 'IN_PROGRESS', description: 'In Progress')
    Ref::WorkStatus.create(value: 'COMPLETED', description: 'Completed')

    # Reference values for credit card payment method
    Ref::CreditCardTransactionType.enumeration_model_updates_permitted = true
    Ref::CreditCardTransactionType.create(value: 'AUTHORIZATION', description: 'Authorization')
    Ref::CreditCardTransactionType.create(value: 'SETTLEMENT', description: 'Payment Settlement')
    Ref::CreditCardTransactionType.create(value: 'TOPUP', description: 'Top Up')
    Ref::CreditCardTransactionType.create(value: 'REVERSAL', description: 'Payment Reversal')
    Ref::CreditCardTransactionType.create(value: 'REFUND', description: 'Payment Refund')
    Ref::CreditCardTransactionType.create(value: 'PAYMENT', description: 'Sale')
    Ref::CreditCardTransactionType.create(value: 'TOKEN', description: 'Create Token')

    Ref::ExternalReferenceType.enumeration_model_updates_permitted = true
    Ref::ExternalReferenceType.create(value: 'CONFIRMATION_NUMBER', description: 'Confirmation Number')


    # Ref values for activity types
    Ref::ActivityType.enumeration_model_updates_permitted = true
    Ref::ActivityType.create(value: 'LOGIN', description: 'Login')
    Ref::ActivityType.create(value: 'LOGOUT', description: 'Logout')

    Ref::AnalyticsService.enumeration_model_updates_permitted = true
    Ref::AnalyticsService.create(value: 'GOOGLE', description: 'Google Analytics')
   
    # Ref values for Campaign Audience Types.
    Ref::CampaignAudienceType.enumeration_model_updates_permitted = true
    Ref::CampaignAudienceType.create(value: 'DUE_IN_GUESTS', description: 'Due In Guests')
    Ref::CampaignAudienceType.create(value: 'IN_HOUSE_GUESTS', description: 'In House Guests')
    Ref::CampaignAudienceType.create(value: 'EVERYONE', description: 'Everyone')
    Ref::CampaignAudienceType.create(value: 'SPECIFIC_USERS', description: 'Specific Users')
    
    # Ref values for campaign types
    Ref::CampaignType.enumeration_model_updates_permitted = true
    Ref::CampaignType.create(value: 'MESSAGE', description: 'Message')
  end

end
