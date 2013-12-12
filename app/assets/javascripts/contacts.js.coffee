Namespace("App.Contacts");

App.Contacts =
  $$$: {}
  
  countryCode: null
  
  init: ->
    @cacheElements()
    @bindingElements()
    @initializePlugins()

  cacheElements: ->
    @$$$.body = $("body")
    @$$$.countryField = $('#contact_country_code')
    @$$$.regionsContainer = $('#region-container')
    @$$$.contactFirstName = $('#contact_first_name')
    @$$$.contactLastName = $('#contact_last_name')
    @$$$.contactRegion = $('#contact_state_code')
    @$$$.phonePrefix = $("#phone-prefix h4")
    @$$$.phoneSets = $("fieldset#phones-sets")
    @$$$.phoneInputs = $('.phone')
    @$$$.emailInputs = $('.email')
    @$$$.tagsInput = $('#tags-input')
    @$$$.tagsList = $('#contact_tag_list')
    @$$$.removeTagBtn = $('.remove-tag')
    @$$$.addPhoneBtn = $('a#add-phone-button')
    @$$$.formInputs = $('form input, form select')
    @$$$.formSubmitBtn =$('form#new_contact input[type=submit], form[id*=edit_contact] input[type=submit]')
    @$$$.form =$('form#new_contact, form#edit_contact')
    @$$$.selectOrganization = $('select#contact_organization_id')
    @$$$.newOrganizationForm = $('fieldset#new-organization')
    
  
  bindingElements: ->
    @$$$.countryField.change @getCountryCode
    @$$$.tagsInput.keypress @addTag
    $(document).on 'click', ".remove-tag", @removeTag
    @$$$.addPhoneBtn.click @addPhoneField
    $(document).on "change", ".phone", @validatePhone
    $(document).on "change", ".email", @validateEmail
    $(document).on "keypress", "input[id*=contact_telephones]", @canEditPhoneInput
    $('input#contact_first_name, input#contact_last_name').keypress @onlyLetters
    @$$$.body.on 'change', 'form input, form select', @validateForm
    @$$$.form.submit @validateFormSubmit
    @$$$.selectOrganization.change @showNewOrganizationForm
  
  initializePlugins: ->
    @validateForm()
    $("label.control-label.required").tooltip
      title: "Campo requerido"
    
  
  getCountryCode: ->
    countryCode = $(this).val();
    $.get("/countries/#{countryCode}", (data) =>
      App.Contacts.$$$.phoneInputs.val("+#{data.country_code}")
      App.Contacts.$$$.regionsContainer.html(HandlebarsTemplates["contacts/regions"](data))
      App.Contacts.$$$.phonePrefix.html("Codigo del pais que ha seleccionado: +" + data.country_code)
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
    App.Errors.show("El campo pais es requerido", "Para continua, seleccione un pais de la lista")
  
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
        App.Errors.show("Telefono no valido", "Revise el telefono que ingreso")
      else
        that.removeClass "error"
    $('#example').tooltip(options)
  
  validateEmail: ->
    email = $(this).val()
    emailRegexp = /\S+@\S+\.\S+/
    if emailRegexp.test(email)
      $(this).removeClass "error"
    else
      $(this).addClass "error"
      App.Errors.show("Email no valido", "Revise el email que ingreso")
      
  
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
      App.Contacts.$$$.formSubmitBtn.popover 'destroy'
    else
      missingFields = App.Contacts.missingRequiredFields().join(", ")
      App.Contacts.$$$.formSubmitBtn.attr('data-content', missingFields)
      App.Contacts.$$$.formSubmitBtn.popover 'show'
      App.Contacts.$$$.formSubmitBtn.addClass("disabled")
  
  missingRequiredFields: ->
    missingField = []
    unless App.Contacts.countryPresent()
      missingField.push "Pais"
    unless App.Contacts.firstNamePresent()
      missingField.push "Nombre"
    unless App.Contacts.LastNamePresent()
      missingField.push "Apellido"
    unless App.Contacts.regionPresent()
      missingField.push "Region"
    missingField
    
  
  validateFormSubmit: (event) ->    
    if !App.Contacts.countryPresent() && !App.Contacts.firstNamePresent() && !App.Contacts.LastNamePresent() && !App.Contacts.regionPresent()
      event.preventDefault()
      App.Errors.show("Faltan campos requeridos", "Ingrese todos los campos requeridos para continuar")
      
  showNewOrganizationForm: ->
    if $(@).val() == 'crear_nuevo'
      App.Contacts.$$$.newOrganizationForm.show()
    else
      App.Contacts.$$$.newOrganizationForm.hide()
      
  
$("#contacts-filters select#filters_countries_code, #contacts-filters #filters_organizations,  #contacts-filters #filters_organization_kinds, #contacts-filters #filters_political_positions, #contacts-filters #filters_level_of_trust, #contacts-filters #filters_tags, #contacts-filters #cols").chosen()

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

$(document).on 'keypress', 'form#filters-contacts-form input', (event) ->
  keyCode = event.keyCode
  if(keyCode  == 13)
    $('form#filters-contacts-form').submit()