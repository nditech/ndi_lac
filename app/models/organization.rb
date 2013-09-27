class Organization < ActiveRecord::Base
  audited
  
  has_many :contacts
end
