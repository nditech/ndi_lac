class ExportExcelController < ApplicationController

  def create
    @cols = params[:cols]
    @contacts = Contact.filters(params[:filters])
    respond_to do |format|
      format.xls
    end
  end
end
