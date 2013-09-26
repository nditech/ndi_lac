class OrganizationsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @organizations = Organization.all
  end
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new organization_params
    if @organization.save
      redirect_to organizations_url, notice: 'Organization create successfully.'
    else
      render :new, error: 'There is some errors in your organization.'
    end
  end
  
  def edit
    @organization = Organization.find params[:id]
  end
  
  def update
    @organization = Organization.find params[:id]
    if @organization.update_attributes organization_params
      redirect_to organizations_url, notice: 'Organization create successfully.'
    else
      render :new, error: 'There is some errors in your organization.'
    end
  end
  
  private
  
  def organization_params
    params.require(:organization).permit(
      :name,
      :address,
      :address_2,
      :country_code,
      :state_code,
      :city,
    )
  end
end
