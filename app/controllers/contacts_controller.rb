class ContactsController < ApplicationController
  load_and_authorize_resource
  
  def show
    @contact = Contact.find params[:id]
  end
  
  def index
    @contacts = if current_user.all_countries?
       Contact.page(params[:page])
    else
      Contact.where(country_code: current_user.country_code).page(params[:page])
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
    @contact = Contact.new contact_params
    if @contact.save
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
    if @contact.update_attributes contact_params
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
end
