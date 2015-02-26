require 'i18n_extensions'
class UserNotifier < ActionMailer::Base
  default from: 'no-reply@stayntouch.com'
  # default_url_options[:host] = Setting.app_host

  def activation(user, hotel = nil)
    setup_email(user)
    email_template = EmailTemplate.find_by_title('Activation Email Text')
    @subject    = "#{email_template.subject}"
    root_url = UserNotifier.default_url_options[:host]
    from_address = 'no-reply@stayntouch.com'
    support_from_address = 'support@stayntouch.com'
    hotel_name = hotel ? hotel.name : ''
    community_name = Setting.community_name || "" 
    user_detail = user.detail || user.staff_detail
    first_name = user_detail ? user_detail.first_name.to_s : ""
    email_body = email_template.body.gsub('@snt_logo', "#{root_url}/assets/logo.png")
        .gsub('@hotel_name', hotel_name)
        .gsub('@first_name',  first_name)
        .gsub('@community_name', community_name)
        .gsub('@user_email', user.email)
        .gsub('@from_address', support_from_address)
        .gsub('@url', root_url)
        .gsub('@address', from_address)
    mail(to: @recipients, subject: @subject, body: email_body, content_type: 'text/html')
  end

  def invitation(user, hotel, password = nil)
    setup_email(user)
    host =  UserNotifier.default_url_options[:host]
    @hotel = hotel
    root_url = UserNotifier.default_url_options[:host]
    if user.hotel_admin?
      if password 
        email_template = EmailTemplate.find_by_title('Unlock a User Email Text')
      else
        email_template = EmailTemplate.find_by_title('Hotel Admin Invitation Email Text')
      end
    else
      email_template = EmailTemplate.find_by_title('User Invitation Email Text')
    end
    @subject    = "#{email_template.subject}"
     @url = "#{host}/api/password_resets/#{user.perishable_token}/activate_user.html"
    from_address = 'no-reply@stayntouch.com'
    support_from_address = 'support@stayntouch.com'
    user_detail = user.detail || user.staff_detail
    first_name = user_detail ? user_detail.first_name.to_s : ""
    password = password ? password : ''
    email_body = email_template.body.gsub('@snt_logo', "#{host}/assets/logo.png")
        .gsub('@hotel_name', hotel.name)
        .gsub('@first_name', first_name)
        .gsub('@user_email', user.email)
        .gsub('@from_address', support_from_address)
        .gsub('@url', @url)
        .gsub('@address', from_address)
        .gsub('@password', password) 

    mail(from: from_address, to: @recipients, subject: @subject, body: email_body, content_type: 'text/html')
  end

  def send_guest_email_verification(user)
    support_from_address = 'support@stayntouch.com'
    hotel_chain = user.hotel_chain
    email_id = user.guest_detail.email
    host =  UserNotifier.default_url_options[:host]
     @url = host + "/guest_web/home/user_activation?perishable_token=#{user.perishable_token}&password_reset=false&chain_code=#{hotel_chain.code}"
    mail(from: support_from_address, to: email_id, subject: I18n.t('mailer.subject.email_verification')) do |format|
      format.html { render 'guest_email_verification' }
    end
  end

  def send_guest_password_reset_email(user)
    support_from_address = 'support@stayntouch.com'
    hotel_chain = user.hotel_chain
    email_id = user.guest_detail.email
    host =  UserNotifier.default_url_options[:host]
    @url = host + "/guest_web/home/user_activation?perishable_token=#{user.perishable_token}&password_reset=true&chain_code=#{hotel_chain.code}"
    mail(from: support_from_address, to: email_id, subject: I18n.t('mailer.subject.password_reset')) do |format|
      format.html { render 'guest_password_reset' }
    end
  end


  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @sent_on     = Time.now
    @user = user
  end
end
