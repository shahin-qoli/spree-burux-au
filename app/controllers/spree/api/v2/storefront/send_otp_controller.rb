module Spree
  module Api
    module V2
      module Storefront
        class SendOtpController < ::Spree::Api::V2::BaseController
          include Spree::Core::ControllerHelpers::Store

          def create
            user = Spree.user_class.find_by(mobile_number: params[:mobile_number])

            if user
              user.otp_secret = Spree::User.generate_otp_secret
              username = user.email
              otp_code = user.current_otp
              @mobile = user.mobile_number
              username = user.email
              request_url  = "https://sms.magfa.com/api/http/sms/v1?service=enqueue&username=paydar_75116&password=V7WXGbTUEZMZVoJT&domain=magfa&from=300075116&to=#{@mobile}&text=code for login to BuruxShop is #{otp_code}"
              HTTParty.get(request_url)              
              head :ok
            else
              head :not_found
            end
          end
          ###

        end
      end
    end
  end
end
