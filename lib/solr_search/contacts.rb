module SolrSearch
  module Contacts
    
    def self.included(base)
      base.class_eval do
        searchable do
          string :first_name, stored: true do
            first_name.downcase
          end
          string :last_name, stored: true do
            last_name.downcase
          end
          string :email, stored: true do
            email.downcase
          end
          string :address,  stored: true
          string :address_2,  stored: true
          string :country_code
          string :state_code
          string :city, stored: true
          string :telephone, stored: true
          string :cellphone, stored: true
          integer :organization_id, stored: true
          string :position, stored: true
          integer :political_position, stored: true
          integer :level_trust, stored: true
          string :tags, stored: true, multiple: true do
            tags.map {|tag| tag.name}
          end
        end
        
        def self.filters(filters)
          (search do
            with(:first_name, filters[:first_name].downcase) if filters[:first_name].present?
            with(:last_name, filters[:last_name].downcase) if filters[:last_name].present?
            with(:email, filters[:email].downcase) if filters[:email].present?
            with(:country_code).any_of(filters[:countries_code]) if filters[:countries_code].present?
            with(:organization_id).any_of(filters[:organizations]) if filters[:organizations].present?
            with(:political_position).any_of(filters[:political_positions]) if filters[:political_positions].present?
            with(:level_trust).any_of(filters[:level_of_trust]) if filters[:level_of_trust].present?
            with(:tags).any_of(filters[:tags]) if filters[:tags].present?
          end).results
        end
      end
    end
    
  end
end
