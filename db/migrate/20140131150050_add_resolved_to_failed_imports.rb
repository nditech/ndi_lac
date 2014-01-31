class AddResolvedToFailedImports < ActiveRecord::Migration
  def change
    add_column :failed_imports, :resolved, :boolean, default: false
  end
end
