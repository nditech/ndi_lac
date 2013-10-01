class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.string :kind
      t.integer :contact_id

      t.timestamps
    end
  end
end
