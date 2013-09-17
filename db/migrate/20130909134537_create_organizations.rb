class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :country_code
      t.string :state_code
      t.string :address
      t.string :address_2
      t.string :city

      t.timestamps
    end
  end
end
