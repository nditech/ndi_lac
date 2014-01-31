class FailedImport < ActiveRecord::Base
  
  belongs_to :import
  belongs_to :contact
  
  def self.unresolved
    where(resolved: false)
  end
  
  def contact_params
    return @contact_params if @contact_params
    @contact_params = ActiveSupport::HashWithIndifferentAccess.new contact_attributes
    @contact_params['telephones_attributes'] = eval(contact_attributes['telephones_attributes']).map {|telephone_attribute| ActiveSupport::HashWithIndifferentAccess.new telephone_attribute}
    @contact_params['emails_attributes'] = eval(contact_attributes['emails_attributes']).map {|email_attribute| ActiveSupport::HashWithIndifferentAccess.new email_attribute}
    @contact_params
  end
  
  def resolve!
    update_attribute :resolved, true
    import.complete_if_not_failed_imports!
  end
  
  def differences
    (contact.attributes.to_a - contact_params.to_a).map &:first
  end
end
