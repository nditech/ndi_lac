class Contact < ActiveRecord::Base
  
  belongs_to :organization
  
  include SolrSearch::Contacts
  
  acts_as_taggable
  
  POLITICAL_POSITIONS = {
    '1' => 'left',
    '2' => 'center-left',
    '3' => 'center',
    '4' => 'center-right',
    '5' => 'right'
  }
  
  def name
    "#{first_name} #{last_name}"
  end
end
