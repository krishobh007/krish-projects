require 'i18n_extensions'
require 'seeds/test/users.rb'
require 'seeds/test/product_config.rb'
require 'seeds/test/hotels.rb'
require 'seeds/test/hotel_chains.rb'
require 'seeds/test/hotel_brands.rb'
require 'seeds/test/external_mappings.rb'
require 'seeds/test/url_mappings.rb'
require 'seeds/test/upsell_amounts.rb'
require 'seeds/test/upsell_room_levels.rb'
require 'seeds/test/late_checkout.rb'
require 'seeds/test/features.rb'
require 'seeds/test/charge_group.rb'
require 'seeds/test/charge_code.rb'
require 'seeds/test/departments.rb'
require 'seeds/test/review_categories.rb'
require 'seeds/test/hotel_review_categories.rb'
require 'seeds/test/items.rb'
require 'seeds/test/notification_details.rb'
require 'seeds/test/reviews.rb'
require 'seeds/test/hotel_payment_type_setup.rb'
require 'seeds/test/rates.rb'
require 'seeds/test/accounts.rb'
require 'seeds/test/contracts.rb'
require 'seeds/test/contract_nights.rb'
require 'seeds/test/end_of_day_process.rb'
require 'seeds/test/cms_components.rb'
require 'seeds/test/printer_templates.rb'

include SeedTestUsers
include SeedTestProductConfig
include SeedTestHotels
include SeedTestHotelChains
include SeedTestHotelBrands
include SeedTestExternalMappings
include SeedTestURLMappings
include SeedTestUpsellAmounts
include SeedTestUpsellRoomLevels
include SeedLateCheckout
include SeedTestFeatures
include SeedChargeGroup
include SeedChargeCode
include SeedDepartments
include SeedTestReviewCategories
include SeedTestHotelReviewCategories
include SeedTestItems
include SeedNotificationDetails
include SeedReviews
include SeedHotelPaymentTypes
include SeedRate
include SeedAccount
include SeedContract
include SeedContractNight
include CmsComponents
include SeedYotelPrinterTemplates

namespace :db_test do
  desc "Seed test data"

  # Seed all test data (including production data) by invoking the appropriate rake tasks
  task :seed do
    unless Rails.env == 'production' || Rails.env == 'qa'
      # Invoke the production seed tasks
      Rake::Task["db:seed"].invoke

      create_test_hotel_chains
      create_test_hotel_brands
      create_test_hotels
      create_test_users
      create_test_product_config
      create_test_external_mappings
      create_test_url_mappings
      create_test_upsell_amounts
      create_test_upsell_room_levels
      create_charge_group
      create_charge_code
      create_late_checkout
      create_test_features
      create_departments
      create_test_review_categories
      create_test_hotel_review_categories
      create_test_items
      create_notification_details
      create_reviews
      create_payment_types
      create_rate
      create_account
      create_contract
      create_contract_nights
      create_cms_components
      create_yotel_printer_templates
    else
      raise "Error: Cannot run test seeds in production or qa environments"
    end
  end
end
