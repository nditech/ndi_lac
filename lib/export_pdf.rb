class ExportPdf < Prawn::Document

  def initialize(contacts, cols)
    super()
    @contacts = contacts
    @cols = cols
    render_contacts
  end
  
  def render_contacts
    @contacts.each do |contact|
      font_size 12 do
        @cols.each do |col|
          if col == 'country_code'
            country_code = contact.send col
            if country_code.present?
              text "#{col.humanize}: #{Carmen::Country.coded(country_code).name} (#{country_code})"
            else
              text "#{col.humanize}: N/A"
            end
          elsif col == 'tags'
            text "#{col.humanize}: #{contact.tag_list}"
          elsif col == 'organization'
            text "#{col.humanize}: #{contact.organization.name if contact.organization.present?}"
          else
            text "#{col.humanize}: #{contact.send col}"
          end
        end
      end
      move_down 20
      # stroke_axis
    end
  end
end