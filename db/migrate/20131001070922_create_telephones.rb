class CreateTelephones < ActiveRecord::Migration
  def change
    create_table :telephones do |t|
      t.string :number
      t.string :kind
      t.integer :contact_id

      t.timestamps
    end
  end
end
