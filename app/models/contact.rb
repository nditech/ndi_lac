class Contact < ActiveRecord::Base
  audited
  
  belongs_to :organization
  has_many :telephones, dependent: :destroy
  has_many :emails, dependent: :destroy
  
  accepts_nested_attributes_for :telephones, 
      allow_destroy: true, 
      reject_if: :all_blank

  accepts_nested_attributes_for :emails, 
      :allow_destroy => true,
      reject_if: :all_blank
  
  include SolrSearch::Contacts
  
  acts_as_taggable
  
  POLITICAL_POSITIONS = {
    '1' => 'left',
    '2' => 'center-left',
    '3' => 'center',
    '4' => 'center-right',
    '5' => 'right'
  }
  
  GENRE = [
    'female',
    'male',
    'other'
  ]
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def self.import(file) 
    spreadsheet = open_spreadsheet(file) 
    header = spreadsheet.row(1).map {|header_col| header_col.downcase.parameterize('_')} 
    (2..spreadsheet.last_row).each do |i| 
      row = Hash[[header, spreadsheet.row(i)].transpose] 
      
      if row["email"].present? 
        row["emails_attributes"] = [{email: row["email"], kind: "personal"}]  
      end 
      row.delete("email")
      
      if row["country"].present? 
        row["country_code"] = (row["country"].size > 2) ? Carmen::Country.named(row["country"].humanize).try(:code) : row["country"]  
      end 
      row.delete("country")
      
      contact = find_by_id(row["id"]) || new 
      # debugger 
      contact.attributes = row.to_hash 
      contact.save! 
    end 
  end 

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
