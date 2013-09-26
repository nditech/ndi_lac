class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable
         
  before_create :set_default_role

  def country_name
    country_code.present? ? Carmen::Country.coded(country_code).name : 'N/A'
  end
  
  def set_password new_password
    self.password = new_password
    self.password_confirmation = new_password
  end
  
  def role=(new_role)
    remove_role self.role
    add_role new_role
  end
  
  def role
    roles.first.present? ? roles.first.name : 'user_own'
  end
  
  def all_countries?
    has_role?(:admin) || has_role?(:user_all)
  end
  
  def is_admin?
    has_role?(:admin)
  end
  
  private
  
  def set_default_role
    add_role :user_own
  end
end
