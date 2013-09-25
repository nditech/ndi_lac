class ImportExcelController < ApplicationController
  
  def create
    Contact.import(params[:file])
    redirect_to root_url, notice: "Products imported."
  end
end
