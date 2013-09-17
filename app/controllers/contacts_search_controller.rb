class ContactsSearchController < ApplicationController
  
  def create
    @contacts = Contact.filters(params[:filters])
    
    render 'contacts/index'
  end
end
