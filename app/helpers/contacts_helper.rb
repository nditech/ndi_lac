module ContactsHelper
  def cols_to_options(selected = nil)
    options_for_select(
      [['First name', 'first_name'], 
       ['Last name', 'last_name'],
       ['Email', 'email'],
       ['Address', 'address'],
       ['Address 2', 'address_2'],
       ['Country', 'country_code'],
       ['Region', 'state_code'],
       ['City', 'city'],
       ['Telephone', 'telephone'],
       ['Cellphone', 'cellphone'],
       ['Organization', 'organization.name'],
       ['Position', 'position'],
       ['Political position', 'political_position'],
       ['Level of trust', 'level_trust']
     ],
    selected)
    
  end
end
