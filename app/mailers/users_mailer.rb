class UsersMailer < ActionMailer::Base
  default from: "no-response@ndi-lac.parbros.com"

  def welcome_email(user, password)
    @user = user
    @password  = password
    mail(to: @user.email, subject: 'Welcome to NDI Database')
  end
end
