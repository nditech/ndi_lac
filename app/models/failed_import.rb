class FailedImport < ActiveRecord::Base

  belongs_to :import
  belongs_to :contact

  def self.unresolved
    where(resolved: false)
  end

  def contact_params
    return @contact_params if @contact_params
    @contact_params = ActiveSupport::HashWithIndifferentAccess.new contact_attributes

    if contact_attributes['telephones_attributes']
      @contact_params['telephones_attributes'] = eval(c).map {|telephone_attribute| ActiveSupport::HashWithIndifferentAccess.new telephone_attribute}
    else
      @contact_params['telephones_attributes'] = []
    end

    if contact_attributes['emails_attributes']
      @contact_params['emails_attributes'] = eval(contact_attributes['emails_attributes']).map {|email_attribute| ActiveSupport::HashWithIndifferentAccess.new email_attribute}
    else
      @contact_params['emails_attributes'] = []
    end

    @contact_params
  end

  def resolve!
    update_attribute :resolved, true
    import.complete! if import.can_complete?
  end

  def differences
    (contact.attributes.to_a - contact_params.to_a).map &:first
  end

  def organization_name
    Organization.find(@contact_params['organization_id']).name
  end
end
