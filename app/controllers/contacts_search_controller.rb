class ContactsSearchController < ApplicationController
  respond_to :js, :html
  
  def index
    params[:filters][:page] = params[:page]
    @contacts = Contact.filters(params[:filters])
    
    respond_with do |format|
      format.html { render 'contacts/index' }
      format.js { render json: @contacts}
    end
  end

  def create
    params[:filters][:page] = params[:page]
    @contacts = Contact.filters(params[:filters])
    
    respond_with do |format|
      format.html { render 'contacts/index' }
      format.js { render json: @contacts}
    end
  end
end
