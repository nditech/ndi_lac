class CountryAdapter
  
  def initialize(country)
    @country = country
    @regions = country.subregions
    Phoner::Country.load if Phoner::Country.all.blank?
  end
  
  def decorated
    {regions: regions, country_code: country_code}
  end
  
  def regions
    @regions.map {|region| {code: region.code, name: region.name}}
  end
  
  def country_code
    Phoner::Country.all.values.select {|phone| phone.char_3_code == @country.code }.first.country_code
  end
end