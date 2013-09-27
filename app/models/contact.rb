class Contact < ActiveRecord::Base
  audited
  
  belongs_to :organization
  
  include SolrSearch::Contacts
  
  acts_as_taggable
  
  POLITICAL_POSITIONS = {
    '1' => 'left',
    '2' => 'center-left',
    '3' => 'center',
    '4' => 'center-right',
    '5' => 'right'
  }
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1).map {|header_col| header_col.downcase.parameterize('_')}
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      contact = find_by_id(row["id"]) || new
      debugger
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
