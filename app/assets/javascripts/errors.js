Namespace("App.Errors")

App.Errors = {
  $$$: {},
  
  init: function() {
    this.cacheElements();
  },
  
  cacheElements: function() {
    this.$$$.errorContainer = $("#errors-container");
  },
  
  show: function(message, content) {
    $('html, body').animate({ scrollTop: 0 }, 'fast');
    this.renderError(message, content);
  },
  
  renderError: function(message, content) {
    var compiledTemplate = $(this.template(message, content));
    compiledTemplate.appendTo(this.$$$.errorContainer).delay(5000).hide(function() {compiledTemplate.remove();})
  },
  
  template: function(message, content) {    
    return HandlebarsTemplates['errors']({message: message, content: content});
  }
}
  
  