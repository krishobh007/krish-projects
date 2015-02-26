class Admin::HotelChainsController < ApplicationController
  before_filter :check_session
  # GET /hotel_chains
  # GET /hotel_chains.json
  def index
    hotel_chains = HotelChain.all
    data = {}
    data[:chain_list] = hotel_chains.map { |hotel_chain| { value: hotel_chain.id.to_s, name: hotel_chain.name, brands: hotel_chain.hotel_brands.map {|brand| { id: brand.id, name:brand.name}}} } if hotel_chains
    respond_to do |format|
      format.html { render partial: 'chain_list', locals: { data: data,  errors: [] } }
      format.json { render json:  { :status => SUCCESS, :data => data, :errors => [] } }
    end
  end

  # GET /hotel_chains/new
  # GET /hotel_chains/new.json
  def new
    hotel_chain = HotelChain.new
    respond_to do |format|
      format.html { render partial: 'add_new_chain' }
      format.json { render json: hotel_chain }
    end
  end

  # GET /hotel_chains/1/edit
  def edit
    status, errors, data = SUCCESS, [], {}
    hotel_chain = HotelChain.find(params[:id])
    ca_cert = "#{Rails.root}/certs/mli/ca-cert-#{hotel_chain.andand.id}.crt"
    data = {
      value: hotel_chain.id.to_s,
      name: hotel_chain.name,
      hotel_code: hotel_chain.code,
      loyalty_program_name: hotel_chain.membership_types.first.andand.description,
      loyalty_program_code: hotel_chain.membership_types.first.andand.value,
      terms_cond: hotel_chain.settings.privacy_policy,
      terms_cond_phone: hotel_chain.settings.terms_conditions_phone,
      terms_cond_email: hotel_chain.settings.terms_conditions_email,
      sftp_location: hotel_chain.settings.sftp_location,
      sftp_port: hotel_chain.settings.sftp_port,
      sftp_user: hotel_chain.settings.sftp_user,
      sftp_password: hotel_chain.decrypt_pswd(hotel_chain.settings.sftp_password),
      sftp_respath: hotel_chain.settings.sftp_respath,
      ca_certificate_exists: File.exist?(ca_cert).to_s,
      import_frequency: hotel_chain.settings.import_frequency
    }
    membership_levels = hotel_chain.membership_types.count > 0 ? hotel_chain.membership_types.first.membership_levels : []
    data[:lov] = membership_levels.map { |membership_level| { value: membership_level.id.to_s, name: membership_level.membership_level } } if membership_levels

    respond_to do |format|
      format.html { render partial: 'edit_chain_details', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  # POST /hotel_chains
  # POST /hotel_chains.json
  def create
    status, data, errors = SUCCESS, {}, []

    begin
      HotelChain.transaction do
        hotel_chain_attributes = {
          name: params[:name],
          code: params[:hotel_code],
          beacon_uuid_proximity: SecureRandom.uuid
        }

        hotel_chain = HotelChain.new(hotel_chain_attributes)

        hotel_chain.save!

        if params[:loyalty_program_code].present? || params[:loyalty_program_name].present?
          # Save chain membership type
          membership_type_attributes = {
            value: params[:loyalty_program_code],
            description: params[:loyalty_program_name],
            property_type: 'HotelChain',
            property_id: hotel_chain.id,
            membership_class: :HLP
          }

          membership_type = MembershipType.create!(membership_type_attributes)

          # Save membership levels
          if params[:lov]
            params[:lov].each do |membership_level|
              MembershipLevel.create!(membership_level: membership_level , membership_type_id: membership_type.id)
            end
          end
        end

        hotel_chain.settings.privacy_policy = params[:terms_cond].present? ? params[:terms_cond] : nil
        hotel_chain.settings.terms_conditions_email = params[:terms_cond_email]
        hotel_chain.settings.terms_conditions_phone = params[:terms_cond_phone]
        hotel_chain.settings.import_frequency = params[:import_frequency]
        
        # Create the remote SFTP folder for the chain
        hotel_chain.settings.sftp_location = params[:sftp_location]
        hotel_chain.settings.sftp_port = params[:sftp_port]
        hotel_chain.settings.sftp_user = params[:sftp_user]
        hotel_chain.settings.sftp_password = hotel_chain.encrypt_pswd(params[:sftp_password])
        hotel_chain.settings.sftp_respath = params[:sftp_respath]

        # Only validate SFTP settings if at least one SFTP parameter is provided
        if params[:sftp_location].present? || params[:sftp_port].present? || params[:sftp_user].present? || params[:sftp_password].present? || params[:sftp_respath].present?
          unless SftpUtility.new(hotel_chain).create_chain_dir
            status = FAILURE
            errors << 'Invalid FTP Settings'
            fail ActiveRecord::Rollback, 'Invalid FTP settings'
          end
        end
        # chain specific mli certificate upload
        hotel_chain.save_ca_certificate(params[:ca_certificate]) if params[:ca_certificate].present?
      end
    rescue ActiveRecord::RecordInvalid => ex
      status = FAILURE
      errors << ex.message
    end

    render json:  { 'status' => status, 'data' => data, 'errors' => errors }
  end

  # PUT /hotel_chains/1
  # PUT /hotel_chains/1.json
  def update
    errors, status = [], SUCCESS

    begin
      HotelChain.transaction do
        hotel_chain = HotelChain.find(params[:id])

        hotel_chain_attributes = {
          name: params[:name],
          code: params[:hotel_code]
        }

        hotel_chain.attributes = hotel_chain_attributes

        old_code = hotel_chain.code_was

        hotel_chain.save!

        if params[:loyalty_program_code].present? || params[:loyalty_program_name].present?
          membership_type_attributes = {
            value: params[:loyalty_program_code],
            description: params[:loyalty_program_name],
            property_type: 'HotelChain',
            property_id: hotel_chain.id,
            membership_class: :HLP
          }

          membership_type = hotel_chain.membership_types.first

          # Save membership type
          if !membership_type
            membership_type = MembershipType.create!(membership_type_attributes)
          else
            membership_type.update_attributes!(membership_type_attributes)
          end

          # Save membership levels
          if params[:lov]
            #puts params[:lov]
            params[:lov].each do |level_attributes|   
              
              if level_attributes.has_key?("value") && level_attributes[:value]
                membership_level = MembershipLevel.find(level_attributes[:value])
                membership_level.update_attributes!(membership_level: level_attributes[:name])
              else
                membership_type.membership_levels.create!(membership_level: level_attributes[:name])
              end
            end
          end

          # Delete all membership levels not used anymore, only if not linked to a membership
          
          new_names = params[:lov] ? params[:lov].select { |v| v[:name].present? }.map { |v| v[:name] } : []
          levels_to_destroy = new_names.empty? ? membership_type.membership_levels : membership_type.membership_levels.where('membership_level NOT IN (?)', new_names)

          levels_to_destroy.each do |membership_level|
            membership_level.destroy if membership_level.guest_memberships.empty?
          end
        end

        hotel_chain.settings.privacy_policy = params[:terms_cond].present? ? params[:terms_cond] : nil
        hotel_chain.settings.terms_conditions_phone = params[:terms_cond_phone]
        hotel_chain.settings.terms_conditions_email = params[:terms_cond_email]
        hotel_chain.settings.import_frequency = params[:import_frequency]

        # Rename the chain code SFTP directory
        old_sftp_respath = hotel_chain.settings.sftp_respath
        hotel_chain.settings.sftp_location = params[:sftp_location]
        hotel_chain.settings.sftp_port = params[:sftp_port]
        hotel_chain.settings.sftp_user = params[:sftp_user]
        hotel_chain.settings.sftp_password = hotel_chain.encrypt_pswd(params[:sftp_password])
        hotel_chain.settings.sftp_respath = params[:sftp_respath]

        # Only validate SFTP settings if at least one SFTP parameter is provided
        if params[:sftp_location].present? || params[:sftp_port].present? || params[:sftp_user].present? || params[:sftp_password].present? || params[:sftp_respath].present?
          unless SftpUtility.new(hotel_chain).rename_chain_dir(old_code, hotel_chain.code)
            status = FAILURE
            errors << 'Invalid SFTP Settings'
            fail ActiveRecord::Rollback
          end
        end
        if old_sftp_respath != hotel_chain.settings.sftp_respath
          if !SftpUtility.new(hotel_chain).create_chain_dir
            status = FAILURE
            errors << 'Invalid SFTP Settings'
            fail ActiveRecord::Rollback
          else
            if hotel_chain.hotels
              hotel_chain.hotels.each do |hotel|
                SftpUtility.new(hotel.hotel_chain).create_hotel_dir(hotel.code)
              end
            end
          end
        end

      # chain specific mli certificate upload
      hotel_chain.save_ca_certificate(params[:ca_certificate]) if params[:ca_certificate].present?

      end
    rescue ActiveRecord::RecordInvalid => ex
      status = FAILURE
      errors << ex.message
    end

    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
end
