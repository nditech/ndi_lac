class CreateFailedImports < ActiveRecord::Migration
  def change
    create_table :failed_imports do |t|
      t.integer :import_id
      t.hstore :contact_attributes

      t.timestamps
    end
  end
end
