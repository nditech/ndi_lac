class Organization < ActiveRecord::Base
  audited
  
  has_many :contacts
  
  TYPES = {
    "1" => "Non-Governmental Organization",
    "2" => "Think Tank",
    "3" => "Legislative",
    "4" => "Judicial",
    "5" => "Political Party",
    "6" => "Political Movement",
    "7" => "National Government",
    "8" => "State  Government",
    "9" => "Municipal  Government",
    "10" => "Media",
    "11" => "Other"
  }
end
