class FailedImportsController < ApplicationController
  def show
    @failed_import = FailedImport.find params[:id]
  end
  
  def update
    @failed_import = FailedImport.find params[:id]
    if params[:actions] == 'replace'
      @failed_import.contact.replace_attributes @failed_import.contact_params
    end
    @failed_import.resolve!
    redirect_to import_path(@failed_import.import)
  end
end
