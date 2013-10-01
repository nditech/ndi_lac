class ContactsController < ApplicationController
  load_and_authorize_resource
  
  def show
    @contact = Contact.find params[:id]
  end
  
  def index
    @contacts = if current_user.all_countries?
       Contact.all
    else
      Contact.where country_code: current_user.country_code
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
  
  private
  
  def contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :email,
      :address,
      :address_2,
      :country_code,
      :state_code,
      :city,
      :telephone,
      :cellphone,
      :organization_id,
      :position,
      :political_position,
      :level_trust,
      :tag_list,
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
