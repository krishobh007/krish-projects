# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'i18n_extensions'
require 'seeds/production/api_keys.rb'
require 'seeds/production/users.rb'
require 'seeds/production/roles.rb'
require 'seeds/production/roles_permissions.rb'
require 'seeds/production/reference_values.rb'
require 'seeds/production/review_categories.rb'
require 'seeds/production/product_config.rb'
require 'seeds/production/features.rb'
require 'seeds/production/countries.rb'
require 'seeds/production/admin_menus_and_options.rb'
require 'seeds/production/rate_types.rb'
require 'seeds/production/membership_types.rb'
require 'seeds/production/membership_levels.rb'
require 'seeds/production/email_templates.rb'
require 'seeds/production/external_mappings.rb'
require 'seeds/production/url_mappings.rb'
require 'seeds/production/disable_manual_cc_entry.rb'
require 'seeds/production/default_privacy_policy.rb'
require 'seeds/production/report_setup.rb'
require 'seeds/production/payment_types.rb'
require 'seeds/production/work_type_and_tasks.rb'
require 'seeds/production/maid_shifts.rb'
require 'seeds/production/email_template_themes.rb'
require 'seeds/production/email_templates.rb'
require 'seeds/production/carlyle_email_templates.rb'
require 'seeds/production/nikko_email_templates.rb'
require 'seeds/production/yotel_email_templates.rb'
require 'seeds/production/fontainebleau_email_templates.rb'
require 'seeds/production/mgm_email_templates.rb'
require 'seeds/production/eden_email_templates.rb'
require 'seeds/production/galleria_email_templates.rb'
require 'seeds/production/huntley_email_templates.rb'


include SeedApiKeys
include SeedEmailTemplates
include SeedUsers
include SeedRoles
include SeedPaymentTypes
include SeedReferenceValues
include SeedReviewCategories
include SeedProductConfig
include SeedRolesPermissions
include SeedFeatures
include SeedCountries
include SeedAdminMenusAndOptions
include SeedRateTypes
include SeedMembershipTypes
include SeedMembershipLevels
include SeedExternalMappings
include SeedURLMappings
include SeedDefaultManualCCEntry
include SeedDefaultPrivacyPolicy
include SeedDefaultReports
include SeedWorkTypeAndTasks
include SeedMaidShifts
include SeedEmailTemplateThemes
include SeedEmailTemplates
include SeedCarlyleEmailTemplates
include SeedNikkoEmailTemplates
include SeedYotelEmailTemplates
include SeedFontainebleauEmailTemplates
include SeedMGMEmailTemplates
include SeedEdenEmailTemplates
include SeedGalleriaEmailTemplates
include SeedHuntleyEmailTemplates

@logger = Logger.new(STDOUT)
ActiveRecord::Base.logger = @logger
ActionMailer::Base.logger = @logger
ActionController::Base.logger = @logger

create_payment_types
create_reference_values
create_countries
create_features
create_api_keys
create_product_config
create_admin_menus_and_options
create_url_mappings
create_email_templates
create_roles
create_users
create_review_categories
create_roles_permissions
create_rate_types
create_membership_types
create_membership_levels
create_external_mappings
create_disable_manual_credit_card_entry
create_default_privacy_policy
create_reports_setup
create_email_template_themes
create_email_templates
create_carlyle_email_templates
create_nikko_email_templates
create_yotel_email_templates
create_fontainebleau_email_templates
create_mgm_email_templates
create_eden_email_templates
create_galleria_email_templates
create_huntley_email_templates

# COMMENTING OUT QUESTIONABLE SEED CAUSING PRODUCTION ISSUES DUE TO DUPLICATE VALUES BEING CREATED
# create_system_work_type

create_maid_shift
