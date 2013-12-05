class Email < ActiveRecord::Base
  audited
  
  TYPES = [
    'personal',
    'trabajo',
    'otro'
  ]
end
