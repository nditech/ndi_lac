class ContactsSearchController < ApplicationController
  respond_to :js, :html

  def create
    @contacts = Contact.filters(params[:filters])
    
    respond_with do |format|
      format.html { render 'contacts/index' }
      format.js { render json: @contacts}
    end
  end
end
