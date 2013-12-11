class ExportPdf < Prawn::Document

  def initialize(contacts, cols, labels)
    super()
    @contacts = contacts
    @cols = cols
    if labels
      render_labels
    else
      render_contacts
    end
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
          elsif col == 'emails'
            text "#{col.humanize}: #{contact.emails.map(&:email).join(',')}"
          elsif col == 'telephones'
            text "#{col.humanize}:"
            contact.telephones.each do |telephone| 
              y_position = cursor - 10
              draw_text "#{telephone.kind.humanize}: #{telephone.number}", at: [20, y_position]
              move_down 15
            end
          else
            text "#{col.humanize}: #{contact.send col}"
          end
        end
      end
      move_down 20
      y_position = cursor
      vertical_line 100, 300, at: [10, y_position]
      # stroke_axis
    end
  end
  
  def render_labels
    @contacts.each do |contact|
      font_size 12 do
        text contact.name || "N/A"
        text contact.address || "N/A"
        text contact.address_2 || "N/A"
        text "#{contact.city || "N/A"}, #{contact.country_code.present? ? Carmen::Country.coded(contact.country_code).name : "N/A"}"
        move_down 20
        y_position = cursor
      end
    end
  end
end