class Contact < ActiveRecord::Base
  audited
  
  belongs_to :organization
  has_many :telephones, dependent: :destroy
  has_many :emails, dependent: :destroy
  
  accepts_nested_attributes_for :telephones, 
      allow_destroy: true, 
      reject_if: :all_blank

  accepts_nested_attributes_for :emails, 
      :allow_destroy => true,
      reject_if: :all_blank
  
  include SolrSearch::Contacts
  
  acts_as_taggable
  
  POLITICAL_POSITIONS = {
    '1' => 'izquierda',
    '2' => 'centro-izquierda',
    '3' => 'centro',
    '4' => 'centro-derecha',
    '5' => 'derecha'
  }
  
  GENRE = [
    'femenino',
    'masculino',
    'otro'
  ]
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def self.find_by_email email
    where(emails: {email: email}).includes(:emails)
  end
  
  def formatted_state
    if state_code.size > 3
    else
    end
  end
  
  def replace_attributes attributes
    update_attributes attributes
    replace_telephones attributes['telephones_attributes']
    replace_emails attributes['emails_attributes']
    save!
  end
  
  def replace_telephones telephones_attributes
    telephones.delete_all
    telephones_attributes.each do |telephone_attributes|
      telephone = telephones.find_or_create_by_number telephone_attributes[:number]
      telephone.update_attributes telephone_attributes
    end
  end
  
  def replace_emails emails_attributes
    emails.delete_all
    emails_attributes.each do |email_attributes|
      email = emails.find_or_create_by_email email_attributes[:email]
      email.update_attributes email_attributes
    end
  end
end
