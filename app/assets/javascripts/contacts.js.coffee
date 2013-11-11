$('#contact_country_code').change ->
  countryCode = $(this).val();
  template = Handlebars.compile($("#regions-template").html())
  $.get("/countries/#{countryCode }", (data) ->
    $('#contact_telephone, #contact_cellphone').val("+#{data.country_code}")
    $('#region-container').html(template(data))
  )
  $('#phones-sets input[name*=number]').phoneNumber({
    'format': 'international',
    'country': countryCode
  })

  
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

$('#export-to-pdf-button').click (event) ->
  event.preventDefault()
  exportExcelForm = $('form#filters-contacts-form').clone()
  exportExcelForm.attr('action','/export_pdf.pdf').submit()

$('a#add-phone-button').click (event) ->
  event.preventDefault();
  newIndex = $("fieldset#phones-sets input[name*=number]").length;
  template = Handlebars.compile($("#telephone-template").html())
  $('fieldset#phones-sets').append(template({index: newIndex }));

$('a#add-email-button').click (event) ->
  event.preventDefault();
  newIndex = $("fieldset#emails-sets input[name*='[email]']").length;
  template = Handlebars.compile($("#email-template").html())
  $('fieldset#emails-sets').append(template({index: newIndex }));

$('form#new_contact, form[id*=edit_contact]').validate();
  
onlyLetters =  (event) ->
  keyCode = event.keyCode
  if(keyCode  > 32 && (keyCode  < 65 || keyCode  > 90) &&(keyCode  < 97 || keyCode  > 122))
    event.preventDefault()

onlyNumbers =  (event) ->
  keyCode = event.keyCode
  if(keyCode  > 32 && (keyCode  < 48 || keyCode  > 57))
    event.preventDefault()

    
$('input#contact_first_name, input#contact_last_name').keypress onlyLetters    

$(document).on "keypress", "input[id*=contact_telephones]", onlyNumbers
