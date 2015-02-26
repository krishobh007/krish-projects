class HotelChain < ActiveRecord::Base
  include RailsSettings::CachedExtend

  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :name, :splash_content_type, :splash_file_name, :splash_file_size,
                  :splash_updated_at, :welcome_msg, :code, :batch_process_enabled, :is_inactive, :room_status_import_freq,
                  :domain_name, :beacon_uuid_proximity

  has_many :hotels
  has_many :hotel_brands
  has_many :guest_details
  has_many :accounts
  has_many :users
  has_many :membership_types, as: :property
  attr_accessible :icon
  has_attached_file :icon, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':hotel_chain_code/:class/:id/:attachment/:style/:filename'
  attr_accessible :splash

  validates :name, :code,
            presence: true

  validates :name, :code, uniqueness: { case_sensitive: false }

  has_attached_file :splash, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':hotel_chain_code/:class/:id/:attachment/:style/:filename'

  # Reschedule the resque jobs after saving the chain
  after_save :schedule_room_status_import_job

  # If hotel_chain deleted, the hotel_chain.is_inactive = true
  default_scope { where('is_inactive=false') }

  Paperclip.interpolates :hotel_chain_code do |a, s|
    a.instance.code
  end

  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end

  # Dynamically schedule the room status import process for the chain (updates any existing schedules)
  def schedule_room_status_import_job
    if batch_process_enabled && self.persisted?
      freq = room_status_import_freq || Setting.resque_freq_default[:room_status_import]
      Resque.set_schedule("room_status_import_chain_#{id}",
                          every: "#{freq}m", class: 'RoomStatusImport',
                          queue: :Room_Status_Import,
                          description: "Room Status Import - Chain '#{name}'", args: id.to_s)
    end
  end

  def encrypt_pswd(string)
    Base64.encode64(aes(code, string)).gsub(/\s/, '') if string.present?
  end

  def decrypt_pswd(string)
    aes_decrypt(code, Base64.decode64(string)) if string.present?
  end

  def aes(key, string)
    value = nil

    if key.present? && string.present?
      begin
        cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
        cipher.encrypt
        cipher.key = Digest::SHA256.digest(key)
        cipher.iv = initialization_vector = cipher.random_iv
        cipher_text = cipher.update(string)
        cipher_text << cipher.final
        value = initialization_vector + cipher_text
      rescue OpenSSL::Cipher::CipherError => ce
        logger.warn "Cipher Error: #{ce.message}"
      end
    end

    value
  end

  def aes_decrypt(key, encrypted)
    value = nil

    if key.present? && encrypted.present?
      begin
        cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
        cipher.decrypt
        cipher.key = Digest::SHA256.digest(key)
        cipher.iv = encrypted.slice!(0, 16)
        d = cipher.update(encrypted)
        d << cipher.final

        value = d
      rescue OpenSSL::Cipher::CipherError => ce
        logger.warn "Cipher Error: #{ce.message}"
      end
    end

    value
  end

  def save_ca_certificate(raw_post_cert)
    base64_data = raw_post_cert.split('base64,')[1]
    file_name = "ca-cert-#{id}.crt"
    image_path = Rails.root.join('certs', 'mli', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(Base64.decode64(base64_data))
      file.close
    end
  end
end
