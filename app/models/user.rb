class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable
         
  def country_name
    country_code.present? ? Carmen::Country.coded(country_code).name : 'N/A'
  end
  
  def set_password new_password
    self.password = new_password
    self.password_confirmation = new_password
  end
end
