class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :country_code
      t.string :state_code
      t.string :telephone
      t.string :cellphone
      t.string :position
      t.integer :political_position
      t.string :address
      t.string :address_2
      t.string :city
      t.integer :level_trust
      t.integer :organization_id

      t.timestamps
    end
  end
end
