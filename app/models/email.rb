class Email < ActiveRecord::Base
  audited
  
  TYPES = [
    'personal',
    'work',
    'other'
  ]
end
