class UsersMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def welcome_email(user, password)
    @user = user
    @passw0rd  = password
    mail(to: @user.email, subject: 'Welcome to NDI Database')
  end
end
