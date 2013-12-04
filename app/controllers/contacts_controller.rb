class ContactsController < ApplicationController
  load_and_authorize_resource
  
  def show
    @contact = Contact.find params[:id]
  end
  
  def index
    @contacts = if current_user.all_countries?
       Contact.filters(page: params[:page])
    else
      Contact.filters(countries_code: current_user.country_code, page: params[:page])
    end
    params[:filters] = {}
    params[:cols] = ['first_name', 'last_name', 'emails', 'telephones']
  end
  
  def new
    @contact = Contact.new
    @contact.telephones.new
    @contact.emails.new
  end
  
  def create
    @contact = Contact.new cleaned_params
    if @contact.save
      create_organization
      redirect_to contacts_url, notice: 'Contact create successfully.'
    else
      render :new, error: 'There is some errors in your contact.'
    end
  end
  
  def edit
    @contact = Contact.find params[:id]
    @contact.telephones.new if @contact.telephones.empty?
    @contact.emails.new if @contact.emails.empty?
  end
  
  def update
    @contact = Contact.find params[:id]
    if @contact.update_attributes cleaned_params
      create_organization
      redirect_to contacts_url, notice: 'Contact create successfully.'
    else
      render :new, error: 'There is some errors in your contact.'
    end
  end
  
  def validate_phone_number
    valid_phone = GlobalPhone.validate(params[:phone_number])
    puts "================"
    puts "Phone #{params[:phone_number]} valid: #{valid_phone}"
    render json: {valid: valid_phone}
  end
  
  private
  
  def contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :address,
      :address_2,
      :country_code,
      :state_code,
      :city,
      :organization_id,
      :position,
      :political_position,
      :level_trust,
      :tag_list,
      :contacted_by,
      :facebook,
      :twitter,
      :genre,
      :ndi_consultant,
      :probono,
      :contacted_by,
      telephones_attributes: [
        :kind, 
        :number,
        :_destroy,
        :id
      ],
      emails_attributes: [
        :email,
        :kind,
        :id,
        :_destroy
      ]
    )
  end
  
  def organization_params
    params.require(:organization).permit(
    :name,
    :kind
    )
  end
  
  def cleaned_params    
    if contact_params[:organization_id] == 'crear_nuevo'
      contact_params.except(:organization_id)
    else
      contact_params
    end
  end
  
  def create_organization
    if contact_params[:organization_id] == 'crear_nuevo'
      organization = Organization.find_or_create_by_name organization_params
      @contact.organization = organization
      @contact.save
    end
  end
end
