class AddNdiActivityToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :national_leadership_program, :boolean
    add_column :contacts, :regional_leadership_program, :boolean
    add_column :contacts, :results_democracy, :boolean
    add_column :contacts, :ndi_activity, :string
  end
end
