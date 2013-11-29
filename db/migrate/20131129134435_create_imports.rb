class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :path_file
      t.integer :user_id
      t.string :status
      t.integer :total_rows
      t.integer :imported_rows
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
