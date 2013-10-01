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
          elsif col == 'emails'
            text "#{col.humanize}:"
            contact.emails.each do |email|
              y_position = cursor - 10
              draw_text "#{email.kind.humanize}: #{email.email}", at: [20, y_position]
              move_down 15
            end
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
end