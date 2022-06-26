class Spree::UsersController < ApplicationController
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
    @mobile = '09124769630'#params['user']['mobile_number']

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
    redirect_to home_index_path 
    
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