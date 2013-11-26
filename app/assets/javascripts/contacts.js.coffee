Namespace("App.Contacts");

App.Contacts =
  $$$: {}
  
  countryCode: null
  
  init: ->
    @cacheElements()
    @bindingElements()

  cacheElements: ->
    @$$$.countryField = $('#contact_country_code')
    @$$$.regionsContainer = $('#region-container')
    @$$$.contactFirstName = $('#contact_first_name')
    @$$$.contactLastName = $('#contact_last_name')
    @$$$.contactRegion = $('#contact_state_code')
    @$$$.phonePrefix = $("#phone-prefix h4")
    @$$$.phoneSets = $("fieldset#phones-sets")
    @$$$.phoneInputs = $('.phone')
    @$$$.tagsInput = $('#tags-input')
    @$$$.tagsList = $('#contact_tag_list')
    @$$$.removeTagBtn = $('.remove-tag')
    @$$$.addPhoneBtn = $('a#add-phone-button')
    @$$$.formInputs = $('form input, form select')
    @$$$.formSubmitBtn =$('form input[type=submit]')
    @$$$.form =$('form#new_contact, form#edit_contact')
    
  
  bindingElements: ->
    @$$$.countryField.change @getCountryCode
    @$$$.tagsInput.keypress @addTag
    $(document).on 'click', ".remove-tag", @removeTag
    @$$$.addPhoneBtn.click @addPhoneField
    $(document).on "change", ".phone", @validatePhone
    $(document).on "keypress", "input[id*=contact_telephones]", @canEditPhoneInput
    $('input#contact_first_name, input#contact_last_name').keypress @onlyLetters
    @$$$.formInputs.change @validateForm
    @$$$.form.submit @validateFormSubmit
  
  
  getCountryCode: ->
    countryCode = $(this).val();
    $.get("/countries/#{countryCode}", (data) =>
      App.Contacts.$$$.phoneInputs.val("+#{data.country_code}")
      App.Contacts.$$$.regionsContainer.html(HandlebarsTemplates["contacts/regions"](data))
      App.Contacts.$$$.phonePrefix.html("Country code for the country you selected: +" + data.country_code)
      App.Contacts.$$$.phoneSets.attr('data-country-code', data.country_code)
      App.Contacts.$$$.contactRegion = $('#contact_state_code')
    )
  
  removeTag: (event) ->
    event.preventDefault()
    tagListValue = App.Contacts.$$$.tagsList.val().split(',')
    tagName = $(this).data('tag')
    index = tagListValue.indexOf(tagName)
    tagListValue.splice(index, 1);
    App.Contacts.$$$.tagsList.val(tagListValue.join(","))
    $(this).parent().remove()
  
  addTag: (event) ->
    tagValue = $(this).val()
    if(event.which == 13)
      event.preventDefault()

    if(event.which == 13 &&  tagValue != '')
      $(this).val('')
      $('.tag_list').append(App.Contacts.removeTagBtn(tagValue))
      tagListValue = App.Contacts.$$$.tagsList.val().split(',')
      tagListValue.push(tagValue)
      App.Contacts.$$$.tagsList.val(tagListValue.join(","))
  
  removeTagBtn: (tagValue) ->
    tagElement = $('<span/>').addClass('label').addClass('label-primary')
    tagElement.html(tagValue)
    removeLink = $('<a/>').addClass('remove-tag').html('X').attr('href','#').attr('data-tag', tagValue)
    tagElement.append(removeLink)
  
  countryRequiredError: ->
    App.Errors.show("Country Field is required", "Please, select a country in the list to continue")
  
  addPhoneField: (event) ->
    event.preventDefault();
    newIndex = $("fieldset#phones-sets input[name*=number]").length;
    template = HandlebarsTemplates['contacts/phone'];
    countryCode = "+" + $("fieldset#phones-sets").data('country-code')
    country = $('#contact_country_code').val()
  
    if country != ""
      $(template).find(".phone").val(countryCode)
      $('fieldset#phones-sets').append(template({index: newIndex }));
      $(template).find(".phone").val(countryCode)
    else
      event.preventDefault()
      App.Contacts.countryRequiredError()
  
  onlyLetters:  (event) ->
    keyCode = event.keyCode
    if(keyCode  > 32 && (keyCode  < 65 || keyCode  > 90) &&(keyCode  < 97 || keyCode  > 122))
      event.preventDefault()

  onlyNumbers:  (event) ->
    keyCode = event.keyCode
    if(keyCode  > 32 && (keyCode  < 48 || keyCode  > 57))
      event.preventDefault()
  
  validatePhone: ->
    phoneNumber = $(this).val()
    that = $(this)
    $.get "/contacts/validate_phone_number", {phone_number: phoneNumber}, (data) ->
      if data.valid == "false" || data.valid == false || data.valid == null
        that.addClass "error"
        App.Errors.show("Telephone is not valid", "Please, check the phone you just entered")
      else
        that.removeClass "error"
  
  canEditPhoneInput: (event) ->
    keyCode = event.keyCode
    country = $('#contact_country_code').val()
    if country != ""
      if(keyCode  > 32 && (keyCode  < 48 || keyCode  > 57))
        event.preventDefault()
    else
      event.preventDefault()
      App.Contacts.countryRequiredError()

  countryPresent: ->
    App.Contacts.$$$.countryField.val() != "" && App.Contacts.$$$.countryField.val() != undefined

  firstNamePresent: ->
    App.Contacts.$$$.contactFirstName.val() != "" && App.Contacts.$$$.contactFirstName.val() != undefined
    
  LastNamePresent: ->
    App.Contacts.$$$.contactLastName.val() != "" && App.Contacts.$$$.contactLastName.val() != undefined

  regionPresent: ->
    App.Contacts.$$$.contactRegion.val() != "" && App.Contacts.$$$.contactRegion.val() != undefined

  validateForm: ->
    if App.Contacts.countryPresent() && App.Contacts.firstNamePresent() && App.Contacts.LastNamePresent() && App.Contacts.regionPresent()
      App.Contacts.$$$.formSubmitBtn.removeClass("disabled")
    else
      App.Contacts.$$$.formSubmitBtn.addClass("disabled")
  
  validateFormSubmit: (event) ->    
    if !App.Contacts.countryPresent() && !App.Contacts.firstNamePresent() && !App.Contacts.LastNamePresent() && !App.Contacts.regionPresent()
      event.preventDefault()
      App.Errors.show("Required Field Missing", "Please. fill the required fields to continue")
      

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

$('a#add-email-button').click (event) ->
  event.preventDefault();
  newIndex = $("fieldset#emails-sets input[name*='[email]']").length;
  $('fieldset#emails-sets').append(HandlebarsTemplates['contacts/email']({index: newIndex }));
  $('form#new_contact, form[id*=edit_contact]').validate();    


  
    
