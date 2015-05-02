class AddExceptionMessageToImports < ActiveRecord::Migration
  def change
    add_column :imports, :exception_message, :string
  end
end
