module Spree
  class User < Spree::Base
    devise :two_factor_authenticatable,
           :otp_secret_encryption_key => ENV['OTP_SECRET_ENCRYPTION_KEY']

    include UserAddress
    include UserMethods
    include UserPaymentSource
    if defined?(Spree::Metadata)
      include Metadata
    end
  
    devise :registerable, :recoverable,
           :rememberable, :trackable, :encryptable, encryptor: 'authlogic_sha512'
    devise :confirmable if Spree::Auth::Config[:confirmable]
    devise :validatable if Spree::Auth::Config[:validatable]

    acts_as_paranoid
    after_destroy :scramble_email_and_password

    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }
    
    def send_otp
      #@mobile = params['spree_user']['mobile_number']

      #user = Spree::User.find_by mobile_number: @mobile
      user.otp_secret = Spree::User.generate_otp_secret
      username = user.email
      puts "the request id is HERE "
      puts "the request id is HERE "
      #puts @mobile 
      puts "the request id is HERE " 
      puts username     
      user.save!
      otp_code = user.current_otp
    
      username = user.email
      request_url  = "https://sms.magfa.com/api/http/sms/v1?service=enqueue&username=paydar_75116&password=V7WXGbTUEZMZVoJT&domain=magfa&from=300075116&to=#{@mobile}&text=code for login to BuruxShop is #{otp_code}"
      HTTParty.get(request_url)
      redirect_to spree.admin_login_path
    
    end
    def self.admin_created?
      User.admin.exists?
    end
    def admin?
      has_spree_role?('admin')
    end

    def self.send_confirmation_instructions(attributes = {}, current_store)
      confirmable = find_by_unconfirmed_email_with_errors(attributes) if reconfirmable
      unless confirmable.try(:persisted?)
        confirmable = find_or_initialize_with_errors(confirmation_keys, attributes, :not_found)
      end
      confirmable.resend_confirmation_instructions(current_store) if confirmable.persisted?
      confirmable
    end

    def resend_confirmation_instructions(current_store)
      pending_any_confirmation do
        send_confirmation_instructions(current_store)
      end
    end

    def send_confirmation_instructions(current_store)
      unless @raw_confirmation_token
        generate_confirmation_token!
      end

      opts = pending_reconfirmation? ? { to: unconfirmed_email } : {}
      opts[:current_store_id] = current_store&.id || Spree::Store.default.id
      send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)
    end

    def self.send_reset_password_instructions(attributes={}, current_store)
      recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions(current_store) if recoverable.persisted?
      recoverable
    end

    def send_reset_password_instructions(current_store)
      token = set_reset_password_token
      send_reset_password_instructions_notification(token, current_store.id)

      token
    end

    def send_reset_password_instructions_notification(token, current_store_id)
      send_devise_notification(:reset_password_instructions, token, { current_store_id: current_store_id })
    end

    protected

    def send_on_create_confirmation_instructions(current_store = nil)
      send_confirmation_instructions(current_store || Spree::Store.default)
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

    private

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.login ||= email if email
    end

    def scramble_email_and_password
      self.email = SecureRandom.uuid + "@example.net"
      self.login = email
      self.password = SecureRandom.hex(8)
      self.password_confirmation = password
      save
    end
  end
end
