class ExportExcelController < ApplicationController

  def create
    if params[:cols].nil? && params[:filters].nil?
      report = current_user.reports.find params[:report_id]
    end
    @cols = report.present? ? report.columns_report : params[:cols]
    @contacts = report.present? ? report.contacts : Contact.filters(params[:filters])
    respond_to do |format|
      format.xls {send_data render_to_string, filename: "export-#{Time.now.to_i}.xls", type: "application/xls"}
    end
  end
end
