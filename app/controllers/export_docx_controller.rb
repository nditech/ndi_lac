class ExportDocxController < ApplicationController
  
  def create
    report = current_user.reports.find params[:report_id]
    respond_to do |format|
        format.docx do
          my_html = ExportDocx.new report.contacts, report.columns_report
          file = Htmltoword::Document.create my_html.render, "export-#{Time.now.to_i}.docx"
          send_file file.path, :disposition => "attachment"
          # send_data File.read(file.path), filename: "export-#{Time.now.to_i}.docx", type: "application/docx"
        end
      end
  end
end
