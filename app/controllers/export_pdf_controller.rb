class ExportPdfController < ApplicationController
  def create
    if params[:cols].nil? && params[:filters].nil?
      report = current_user.reports.find params[:report_id]
    end
    @cols = report.present? ? report.columns_report : params[:cols]
    @contacts = report.present? ? report.contacts : Contact.filters(params[:filters])
    respond_to do |format|
      format.pdf do
        pdf = ExportPdf.new(@contacts, @cols)
        send_data pdf.render, filename: "export-#{Time.now.to_i}.pdf", type: "application/pdf"
      end
    end
  end
end
