class Reports::ExportExcelController < ApplicationController
  def create
    report = current_user.reports.find params[:report_id]
    @cols = report.columns_report
    @contacts = report.contacts
    respond_to do |format|
      format.xls
    end
  end
end
