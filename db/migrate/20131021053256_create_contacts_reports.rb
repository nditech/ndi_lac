class CreateContactsReports < ActiveRecord::Migration
  def change
    create_table :contacts_reports do |t|
      t.references :contact, index: true
      t.references :report, index: true

      t.timestamps
    end
  end
end
