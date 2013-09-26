class ContactsController < ApplicationController
  
  def index
    @contacts = if current_user.all_countries?
       Contact.all
    else
      Contact.where country_code: current_user.country_code
    end
    params[:filters] = {}
    params[:cols] = ['first_name', 'last_name', 'email', 'telephone']
  end
  
  def new
    @contact = Contact.new
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
      :tag_list
    )
  end
end
