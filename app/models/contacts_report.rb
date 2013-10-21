class ContactsReport < ActiveRecord::Base
  belongs_to :contact
  belongs_to :report
end
