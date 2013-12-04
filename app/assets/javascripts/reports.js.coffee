$('#submit-contact-search-form-button').click (event) ->
  event.preventDefault();
  $('form#search-contacts-form').submit()

$('form#search-contacts-form').on "ajax:success", (event, xhr, settings) ->
  contactIds = $('textarea#report_contact_ids').val().split(",")
  results = jQuery.parseJSON(xhr)[0]
  template = Handlebars.compile($("#contact-result-template").html())
  contactsArray = []
  $("table#contacts-search-results tbody").html("")
  $.each results.collection, (index, contact) ->
    contact.disabled = (contactIds.indexOf(contact.id.toString()) >= 0)
    contactsArray.push(HandlebarsTemplates['reports/contact-result'](contact))
  if contactsArray.length > 0
    $("table#contacts-search-results tbody").append(contactsArray)

$(document).on "click", "a.add-to-report", (event) ->
  event.preventDefault
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactIds = contactIds.filter (n) -> n
  contact = extractContact($(@))
  contactIds.push contact.id 
  $('textarea#report_contact_ids').val contactIds.join ","
  $("table#contacts-in-report tbody").append(HandlebarsTemplates['reports/contact-report'](contact))
  $(@).attr('disabled','disabled')
  
extractContact = (element) ->
  contactId = element.data("contact-id")
  contactFirstName = element.data("contact-first-name")
  contactLastName = element.data("contact-last-name")
  {'id': contactId, 'first_name': contactFirstName, 'last_name': contactLastName }
  
$(document).on "click", "a.remove-to-report", (event) ->
  event.preventDefault
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactIds = contactIds.filter (n) -> n
  contactId = $(@).data("contact-id").toString()
  index = contactIds.indexOf(contactId)
  delete contactIds[index]
  $('textarea#report_contact_ids').val contactIds.join ","
  $("table#contacts-in-report tbody tr#contact-" + contactId).remove()
  $("table#contacts-search-results tbody a#contact-id-" + contactId).removeAttr("disabled")
  

$("a#add-all-button").click (event) -> 
  event.preventDefault
  $.each $('a.add-to-report[disabled!=disabled]'), (index, link) ->
    $(link).trigger 'click'

$('textarea#report_contact_ids').trigger 'change'

$('#report_columns_report').chosen()