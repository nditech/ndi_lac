class AddFieldsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contacted_by, :string
    add_column :contacts, :genre, :string
    add_column :contacts, :twitter, :string
    add_column :contacts, :facebook, :string
    add_column :contacts, :ndi_consultant, :boolean
    add_column :contacts, :probono, :boolean
    remove_column :contacts, :email
    remove_column :contacts, :telephone
    remove_column :contacts, :cellphone
  end
end
