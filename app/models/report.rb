class Report < ActiveRecord::Base
  belongs_to :user
  has_many :contacts_reports
  has_many :contacts, through: :contacts_reports
  
  def contact_ids
    super.join(",")
  end
  
end
