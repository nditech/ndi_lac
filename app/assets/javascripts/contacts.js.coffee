$('#contact_country_code').change ->
  countryCode = $(this).val();
  template = Handlebars.compile($("#regions-template").html())
  $.get("/countries/#{countryCode }", (data) ->
    $('#contact_telephone, #contact_cellphone').val("+#{data.country_code}")
    $('#region-container').html(template(data))
  )
  
removeTag = (event) ->
  event.preventDefault()
  tagListValue = $('#contact_tag_list').val().split(',')
  tagName = $(this).data('tag')
  index = tagListValue.indexOf(tagName)
  tagListValue.splice(index, 1);
  $('#contact_tag_list').val(tagListValue.join(","))
  $(this).parent().remove()

$('#tags-input').keypress (event) -> 
  tagValue = $(this).val()
  if(event.which == 13)
    event.preventDefault()

  if(event.which == 13 &&  tagValue != '')
    $(this).val('')
    tagElement = $('<span/>').addClass('label').addClass('label-primary')
    tagElement.html(tagValue)
    removeLink = $('<a/>').addClass('remove-tag').html('X').attr('href','#').attr('data-tag', tagValue)
    removeLink.on 'click', removeTag 
    tagElement.append(removeLink)
    $('.tag_list').append(tagElement)
    tagListValue = $('#contact_tag_list').val().split(',')
    tagListValue.push(tagValue)
    $('#contact_tag_list').val(tagListValue.join(","))
    
$('.remove-tag').on 'click', removeTag

$("#contacts-filters select#filters_countries_code, #contacts-filters #filters_organizations, #contacts-filters #filters_political_positions, #contacts-filters #filters_level_of_trust, #contacts-filters #filters_tags, #contacts-filters #cols").chosen()

$('#export-to-excel-button').click (event) ->
  event.preventDefault()
  exportExcelForm = $('form#filters-contacts-form').clone()
  exportExcelForm.attr('action','/export_excel.xls').submit()
  
$('#submit-search-form-button').click (event) ->
  event.preventDefault()
  $('form#filters-contacts-form').submit()
  
$('#import-excel-button').click (event) ->
  event.preventDefault()
  $('form#import-excel-form').submit()
