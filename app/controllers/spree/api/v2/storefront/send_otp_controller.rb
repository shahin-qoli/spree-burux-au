module Spree
  module Api
    module V2
      module Storefront
        class SendOtpController < ::Spree::Api::V2::BaseController
          #include Spree::Core::ControllerHelpers::Store

          def create
            user = Spree.user_class.find_by(mobile_number: params[:mobile_number])

            if user&.send_otp
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
