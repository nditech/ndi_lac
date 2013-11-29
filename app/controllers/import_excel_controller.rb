class ImportExcelController < ApplicationController
  
  def create
    Import.new_file params[:file], current_user.id
    redirect_to root_url, notice: "Products imported."
  end
end
