class ExportPdfController < ApplicationController
  def create
    @cols = params[:cols]
    @contacts = Contact.filters(params[:filters])
    respond_to do |format|
      format.pdf do
        pdf = ExportPdf.new(@contacts, @cols)
        send_data pdf.render, filename: "export-#{Time.now.to_i}.pdf", type: "application/pdf"
      end
    end
  end
end
