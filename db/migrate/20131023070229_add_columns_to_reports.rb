class AddColumnsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :columns_report, :text
  end
end
