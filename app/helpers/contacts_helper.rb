module ContactsHelper
  def cols_to_options(selected = nil)
    options_for_select(
      [['First name', 'first_name'], 
       ['Last name', 'last_name'],
       ['Emails', 'emails'],
       ['Address', 'address'],
       ['Address 2', 'address_2'],
       ['Country', 'country_code'],
       ['Region', 'state_code'],
       ['City', 'city'],
       ['Telephones', 'telephones'],
       ['Organization', 'organization'],
       ['Position', 'position'],
       ['Political position', 'political_position'],
       ['Level of trust', 'level_trust'],
       ['Tags', 'tags'],
     ],
    selected)
    
  end
end
