module Importer

  FIELDS = {
    "nombre" => "first_name",
    "apellido" => "last_name",
    "pais" => "country_code",
    "estado" => "state_code",
    "posicion" => "position",
    "posicion_politica" => "political_position",
    "direccion" => "address",
    "direccion_2" => "address_2",
    "ciudad" => "city",
    "nivel_de_confianza" => "level_trust",
    "contactado_por" => "contacted_by",
    "genero" => "genre",
    "twitter" => "twitter",
    "facebook" => "facebook",
    "consultor" => "ndi_consultant",
    "probono" => "probono",
    "programa_de_liderazgo_nacional" => "national_leadership_program",
    "programa_de_liderazgo_regional" => "regional_leadership_program",
    "democracia_con_resultados" => "results_democracy",
    "actividad_ndi" => "ndi_activity"
  }

  POLITICAL_POSITIONS = {
    'izquierda' => '1',
    'centro-izquierda' => '2',
    'centro' => '3',
    'centro-derecha' => '4',
    'derecha' => '5'
  }

  def import
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1).map {|header_col| header_col.downcase.parameterize('_')}
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      @contact_params = contact_attributes row

      inspect_emails
      inspect_phones
      inspect_booleans
      inspect_organization
      inspect_politcal_position
      inspect_country

      if can_process_contact?
        contact = Contact.new
        contact.attributes = @contact_params.to_hash
        contact.save!
        contact.index!
      else
        self.failed_imports.create contact_attributes: Hash[@contact_params], contact_id: previuos_contact.id
        conflict! if can_conflict?
      end
    end
  end

  def contact_attributes row
    contact_params = {}
    row.each do |key, value|
      contact_params[FIELDS[key] || key] = value unless value.blank?
    end
    contact_params
  end

  def inspect_organization
    organization = Organization.find_or_create_by_name @contact_params['organizacion']
    @contact_params['organization_id'] = organization.id
    @contact_params.delete('organizacion')
  end

  def inspect_emails
    @contact_params["emails_attributes"] = []
    @emails = []

    if @contact_params['email'].present?
      @contact_params["emails_attributes"] << {email: @contact_params["email"], kind: "personal"}
      @emails << @contact_params["email"]
      @contact_params.delete("email")
    end

    if @contact_params['email_personal'].present?
      @contact_params["emails_attributes"] << {email: @contact_params["email_personal"], kind: "personal"}
      @emails << @contact_params["email_personal"]
      @contact_params.delete("email_personal")
    end

    if @contact_params['email_trabajo'].present?
      @contact_params["emails_attributes"] << {email: @contact_params["email_trabajo"], kind: "trabajo"}
      @emails << @contact_params["email_trabajo"]
      @contact_params.delete("email_trabajo")
    end

    if @contact_params['email_otro'].present?
      @contact_params["emails_attributes"] << {email: @contact_params["email_otro"], kind: "otro"}
      @emails << @contact_params["email_otro"]
      @contact_params.delete("email_otro")
    end

    @contact_params.delete("emails_attributes") if @contact_params["emails_attributes"].empty?
  end

  def inspect_phones
    @contact_params["telephones_attributes"] = []

    if @contact_params['telefono'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono"].to_s, kind: "personal"}
      @contact_params.delete("telefono")
    end

    if @contact_params['telefono_personal'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono_personal"].to_s, kind: "personal"}
      @contact_params.delete("telefono_personal")
    end

    if @contact_params['telefono_trabajo'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono_trabajo"].to_s, kind: "trabajo"}
      @contact_params.delete("telefono_trabajo")
    end

    if @contact_params['telefono_casa'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono_casa"].to_s, kind: "casa"}
      @contact_params.delete("telefono_casa")
    end

    if @contact_params['telefono_mobil'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono_mobil"].to_s, kind: "celular/mobil"}
      @contact_params.delete("telefono_mobil")
    end

    if @contact_params['telefono_otro'].present?
      @contact_params["telephones_attributes"] << {number: @contact_params["telefono_otro"].to_s, kind: "otro"}
      @contact_params.delete("telefono_otro")
    end

    @contact_params.delete("telephones_attributes") if @contact_params["telephones_attributes"].empty?
  end

  def inspect_booleans
    if @contact_params['ndi_consultant'].present? && boolean_field_is_marked?(@contact_params['ndi_consultant'].downcase)
      @contact_params['ndi_consultant'] = true
    end

    if @contact_params['probono'].present? && boolean_field_is_marked?(@contact_params['probono'].downcase)
      @contact_params['probono'] = true
    end

    if @contact_params['national_leadership_program'].present? && boolean_field_is_marked?(@contact_params['national_leadership_program'].downcase)
      @contact_params['national_leadership_program'] = true
    end

    if @contact_params['regional_leadership_program'].present? && boolean_field_is_marked?(@contact_params['regional_leadership_program'].downcase)
      @contact_params['regional_leadership_program'] = true
    end

    if @contact_params['results_democracy'].present? && boolean_field_is_marked?(@contact_params['results_democracy'].downcase)
      @contact_params['results_democracy'] = true
    end
  end

  def inspect_politcal_position
    @contact_params['political_position'] = POLITICAL_POSITIONS[@contact_params['political_position']]
  end

  def inspect_country
    if @contact_params["country_code"].present?
      @contact_params["country_code"] = (@contact_params["country_code"].size > 2) ? Carmen::Country.named(@contact_params["country_code"].humanize).try(:code) : @contact_params["country_code"]
    end
  end

  def boolean_field_is_marked? boolean_field
    boolean_field == 'x' || boolean_field == 't' || boolean_field == 'si' || boolean_field == 's'
  end

  def can_process_contact?
    Contact.find_by_email(@emails).blank?
  end

  def previuos_contact
    Contact.find_by_email(@emails).first
  end

  def open_spreadsheet(file)
    case File.extname(file.path)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.path}"
    end
  end

  def file
    File.open(path_file)
  end
end