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
  
  def columns_array
    [['Nombre', 'first_name'], 
     ['Apellido', 'last_name'],
     ['Emails', 'emails'],
     ['Direccion', 'address'],
     ['Direccion 2', 'address_2'],
     ['Pais', 'country_code'],
     ['Region', 'state_code'],
     ['Ciudad', 'city'],
     ['Telefonos', 'telephones'],
     ['Organizacion', 'organization'],
     ['Posicion', 'position'],
     ['Posicion politica', 'political_position'],
     ['Nivel de confianza', 'level_trust'],
     ['Tags', 'tags'],
   ]
  end
end
