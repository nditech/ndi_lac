class Telephone < ActiveRecord::Base
  audited
  
  TYPES = [
      'cellphone',
      'home',
      'personal',
      'work',
      'other'
  ]

  validates_uniqueness_of :number, :scope => :contact_id
end
