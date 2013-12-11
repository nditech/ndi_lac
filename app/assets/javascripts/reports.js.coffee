Namespace("App.Reports");

App.Reports =
  $$$: {}
  
  init: ->
    @cacheElements

  cacheElements: ->
    @$$$.document = $(document)
    @$$$.body = @$$$.document.find("body")
    @$$$.searchContactForm = @$$$.body.find('form#search-contacts-form')
    @$$$.contactSearchSubtmitButton = @$$$.body.find('#submit-contact-search-form-button')
    @$$$.txtAreaContactIds = @$$$.body.find('textarea#report_contact_ids')
    @$$$.tableContactSearchResults = @$$$.body.find("table#contacts-search-results tbody")


$('#submit-contact-search-form-button').click (event) ->
  event.preventDefault();
  $('form#search-contacts-form').submit()

$('form#search-contacts-form').on "ajax:success", (event, xhr, settings) ->
  results = jQuery.parseJSON(xhr)[0]
  filterResults(results)

filterResults = (results) ->
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactsArray = []
  $("table#contacts-search-results tbody").html("")
  $.each results.collection, (index, contact) ->
    contact.disabled = (contactIds.indexOf(contact.id.toString()) >= 0)
    contactsArray.push(HandlebarsTemplates['reports/contact-result'](contact))
  if contactsArray.length > 0
    $("table#contacts-search-results tbody").append(contactsArray)
  addPagination(results)

addPagination = (collection) ->
  $("ul.pagination").html("")
  pagination = 
    pages: collection.pages
    currentPage: collection.current_page
    prev: (collection.current_page - 1)
    prev2: (collection.current_page - 2)
    next: (collection.current_page + 1)
    next2: (collection.current_page + 2)
  $("ul.pagination").append(HandlebarsTemplates['reports/pagination'](pagination))

$(document).on "click", "a.add-to-report", (event) ->
  event.preventDefault()
  contactIds = $('textarea#report_contact_ids').val().split(",")
  contactIds = contactIds.filter (n) -> n
  contact = extractContact($(@))
  contactIds.push contact.id 
  $('textarea#report_contact_ids').val contactIds.join ","
  addContactToReport(contact)
  $(@).attr('disabled','disabled')

$(document).on "click", "ul.pagination a", (event) ->
  event.preventDefault()
  goToPage = $(@).data('to-page')
  filters = $('form#search-contacts-form').serialize() + "&filters[page]=" + goToPage 
  $.ajax '/contacts_search',
    data: filters
    success: (data, status, xhr) ->
      results = jQuery.parseJSON(data)[0]
      filterResults(results)
  

addContactToReport = (contact) ->
  $("table#contacts-in-report tbody").append(HandlebarsTemplates['reports/contact-report'](contact))
  
extractContact = (element) ->
  contactId = element.data("contact-id")
  contactFirstName = element.data("contact-first-name")
  contactLastName = element.data("contact-last-name")
  {'id': contactId, 'first_name': contactFirstName, 'last_name': contactLastName }

loadContacts = ->
  contactIds = $('textarea#report_contact_ids').val()
  if contactIds != ''
    $.ajax '/contacts_search',
      data:
        filters:
          ids: contactIds
          page: 'all'
      success: (data, status, xhr) ->
        results = jQuery.parseJSON(data)[0]
        $.each results.collection, (index, contact) ->
          addContactToReport(contact)

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

loadContacts()