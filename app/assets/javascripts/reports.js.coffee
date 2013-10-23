$('#submit-contact-search-form-button').click (event) ->
  event.preventDefault();
  $('form#search-contacts-form').submit()

$('form#search-contacts-form').on "ajax:success", (event, xhr, settings) ->
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contacts = jQuery.parseJSON(xhr)
  template = Handlebars.compile($("#contact-result-template").html())
  contactsArray = []
  $("table#contacts-search-results tbody").html("")
  $.each contacts, (index, contact) ->
    contact.disabled = (contactIds.indexOf(contact.id.toString()) >= 0)
    contactsArray.push(template(contact))
  if contactsArray.length > 0
    $("table#contacts-search-results tbody").append(contactsArray)

$('textarea#report_contact_ids').on 'change', () ->
  contactIds = $(@).val()
  template = Handlebars.compile($('#contact-to-report-template').html())
  $.ajax 
    url: '/contacts_search'
    type: 'POST'
    data: filters: 
      ids: contactIds
    success: (data) ->
      contacts = jQuery.parseJSON(data)
      $("table#contacts-in-report tbody").html("")
      $('a.add-to-report[disabled]').removeAttr('disabled')
      if contactIds.length > 0
        contactsArray = []
        $.each contacts, (index, contact) ->
          contactsArray.push(template(contact))
          $("a.add-to-report.contact-id-"+contact.id).attr('disabled', 'disabled')
        if contactsArray.length > 0  
          $("table#contacts-in-report tbody").append(contactsArray)

$(document).on "click", "a.add-to-report", (event) ->
  event.preventDefault
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactIds = contactIds.filter (n) -> n
  contactId = $(@).data "contact-id"
  contactIds.push contactId 
  $('textarea#report_contact_ids').val contactIds.join ","
  $('textarea#report_contact_ids').trigger 'change'
  
$(document).on "click", "a.remove-to-report", (event) ->
  event.preventDefault
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactIds = contactIds.filter (n) -> n
  contactId = $(@).data("contact-id").toString()
  index = contactIds.indexOf(contactId)
  delete contactIds[index]
  $('textarea#report_contact_ids').val contactIds.join ","
  $('textarea#report_contact_ids').trigger 'change'

$("a#add-all-button").click (event) -> 
  event.preventDefault
  $.each $('a.add-to-report[disabled!=disabled]'), (index, link) ->
    $(link).trigger 'click'

$('textarea#report_contact_ids').trigger 'change'