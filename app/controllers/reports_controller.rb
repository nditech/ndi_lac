class ReportsController < ApplicationController
  
  def index
    @reports = current_user.reports
  end
  
  def show
    @report = current_user.reports.find params[:id]
  end
  
  def new
    @report = Report.new
    params[:filters] = {}
  end
  
  def create
    @report = current_user.reports.new params[:report]
    @report.contact_ids = report_params[:contact_ids].split(',').uniq
    @report.columns_report = @report.columns_report.reject(&:empty?)
    if @report.save
      redirect_to reports_url, notice: 'Report create successfully.'
    else
      render :new, error: 'There is some errors in your report.'
    end
  end
  
  def edit
    @report = current_user.reports.find params[:id]
    params[:filters] = {}
  end
  
  def update
    @report = current_user.reports.find params[:id]
    edit_report_params = report_params
    edit_report_params[:contact_ids] = edit_report_params[:contact_ids].split(',').uniq
    debugger
    edit_report_params['columns_report'] = edit_report_params['columns_report'].reject(&:empty?)
    if @report.update_attributes(edit_report_params)
      redirect_to reports_url, notice: 'Report create successfully.'
    else
      render :new, error: 'There is some errors in your report.'
    end
  end

  private
  
  def report_params
    params.require(:report).permit(
      :name,
      :description,
      :contact_ids,
      columns_report: []
    )
  end
  
end
