$('#organization_country_code').change ->
  countryCode = $(this).val();
  template = Handlebars.compile($("#regions-template").html())
  $.get("/countries/#{countryCode }", (data) ->
    $('#contact_telephone, #contact_cellphone').val("+#{data.country_code}")
    $('#region-container').html(template(data))
  )