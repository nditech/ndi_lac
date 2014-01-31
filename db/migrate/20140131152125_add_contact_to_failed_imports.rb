class AddContactToFailedImports < ActiveRecord::Migration
  def change
    add_column :failed_imports, :contact_id, :integer
  end
end
