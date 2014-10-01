class UsersMailer < ActionMailer::Base
  default from: "no-response@ndi.org"

  def welcome_email(user, password)
    @user = user
    @password  = password
    mail(to: @user.email, subject: 'Welcome to NDI Database')
  end
end
