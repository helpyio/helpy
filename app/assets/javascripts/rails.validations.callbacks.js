window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();

  parent = element.parent();
  parent.find('span.glyphicon-ok').remove();
  parent.addClass('has-feedback').addClass('has-error').removeClass('has-success');
  element.after('<span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>');
};

window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
  callback();

	parent = element.parent();
  parent.removeClass('has-error').addClass('has-feedback').addClass('has-success');
  parent.find('help-block').remove();
  parent.find('span.glyphicon-remove').remove();
  element.after('<span class="glyphicon glyphicon-ok form-control-feedback" aria-hidden="true"></span>');
};
