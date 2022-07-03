require 'httparty'
require 'json'

class Spree::UsersController < ApplicationController
  def validate_otp(code)
      @mobile = mobile_number
      @code = code
      user = Spree::User.find_by mobile_number: @mobile
      if user.validate_and_consume_otp! @code
        false
      else
        false
      end    
  end  
  def disable_otp
    current_user.otp_required_for_login = false
    current_user.save!
    redirect_to home_index_path
  end

  def enable_otp
    current_user.otp_secret = Spree::User.generate_otp_secret
    current_user.otp_required_for_login = true
    current_user.save!
    redirect_to home_index_path
  end

  def create_otp
    current_user.otp_required_for_login = true
    current_user.save!
    current_user.otp_secret = Spree::User.generate_otp_secret
    current_user.save!
    redirect_to home_index_path
  end 

  def send_otp
    @mobile = params['spree_user']['mobile_number']

    user = Spree::User.find_by mobile_number: @mobile
    user.otp_secret = Spree::User.generate_otp_secret
    username = user.email
    puts "the request id is HERE "
    puts "the request id is HERE "
    puts @mobile 
    puts "the request id is HERE " 
    puts username     
    user.save!
    otp_code = user.current_otp

    username = user.email
    request_url  = "https://sms.magfa.com/api/http/sms/v1?service=enqueue&username=paydar_75116&password=V7WXGbTUEZMZVoJT&domain=magfa&from=300075116&to=#{@mobile}&text=code for login to BuruxShop is #{otp_code}"
    HTTParty.get(request_url)
    redirect_to spree.admin_login_path

  end

  def send_brx_otp 
    current_user.otp_secret = Spree::User.generate_otp_secret
    current_user.save!
    otp_code = current_user.current_otp
    mobile = current_user.mobile_number
    request_url  = "https://sms.magfa.com/api/http/sms/v1?service=enqueue&username=paydar_75116&password=V7WXGbTUEZMZVoJT&domain=magfa&from=300075116&to=#{mobile}&text=#{otp_code}"
    HTTParty.get(request_url)
    redirect_to home_index_path 
  end  
  def otp_login
    render 'devise/sessions/new-otp'
  end  
end 