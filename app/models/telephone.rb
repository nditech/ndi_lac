class Telephone < ActiveRecord::Base
  audited
  
  TYPES = [
      'celular/mobil',
      'casa',
      'personal',
      'trabajo',
      'otro'
  ]

  validates_uniqueness_of :number, :scope => :contact_id
end
