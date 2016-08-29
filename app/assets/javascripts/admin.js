
// Gives us a capitalize method
String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
};

var Helpy = Helpy || {};
Helpy.admin = function(){

  $('table.sortable').sortable({
    items: '.item',
    axis: 'y',
    cursor: 'move',
    sort: function(event, ui) {
      ui.item.addClass('active-item-shadow');
    },
    stop: function(event, ui) {
      ui.item.removeClass('active-item-shadow');
      ui.item.effect('highlight');
    },
    update: function(event, ui) {
      var obj = ui.item.data('obj');
      var obj_id = ui.item.data('obj-id');
      var position = ui.item.index();
      $.ajax({
        type: 'POST',
        url: '/admin/shared/update_order',
        dataType: 'json',
        data: {object: obj, obj_id: obj_id, row_order_position: position }
      });
    }
  });

  $('.settings-link').off().on('click', function(){
    // Clean up any select-styled links
    $('.settings-link').removeClass('active-settings-link');

    // Hide and show the grid/panels
    $('.settings-grid').addClass('hidden');
    $('.settings-panel').removeClass('hidden');

    var $this = $(this);
    var showthis = $this.data('target');
    $('a[data-target=' + showthis + ']').addClass('active-settings-link');
    $('.settings-section').addClass('hidden');
    $('.settings-section.' + showthis).removeClass('hidden');
    $('.agent-header').hide();
    $('h2#setting-header').text('Settings: ' + $this.text().capitalize());
    return false;
  });

  $('.pick-a-color').pickAColor({
    inlineDropdown: true //display underneath field
  });

  // Onboarding flow
  $('.panel-link').off().on('click', function(){
    $('.onboard-panel').addClass('hidden');
    $('#panel-' + $(this).data('panel')).removeClass('hidden');
    $('li.step-' + ($(this).data('panel')-1)).html("<span class='glyphicon glyphicon-ok'></span>").addClass('filled-circle');
    $('li.step-' + $(this).data('panel')).addClass('active-step');
  });

  $('input.send-email').off().on('change', function(){
    var chosen = $("input.send-email:radio:checked").val();
    if (chosen === 'true') {
      $('.smtp-settings').removeClass('hidden');
    } else {
      $('.smtp-settings').addClass('hidden');
    }
  });

  $('.settings-section.email select').off().on('change', function(){
    var chosen = $(".settings-section.email select").val();
      $('.imap-settings').addClass('hidden');
      $('.pop3-settings').addClass('hidden');
    if (chosen == 'pop3' ){
      $('.pop3-settings').removeClass('hidden');
    }
    if (chosen == 'imap' ){
      $('.imap-settings').removeClass('hidden');
    }
  });

  $("#new_doc select, #edit_doc select").focusout(function(){
    if($(this).val() === ""){
      $("div.select").removeClass("has-success").addClass("has-error");
      $("select").next().removeClass("glyphicon-ok").addClass("glyphicon-remove");
      $("div.select .glyphicon-ok").remove();
      $("<span class='help-block'>can't be blank</span>").insertAfter("div.select .glyphicon-remove");
      $('input[type="submit"]').prop('disabled', true);
    }
    else{
     $('input[type="submit"]').prop('disabled', false);
    }
  });

};

Helpy.showPanel = function(panel) {
  var currentPanel = panel-1;
  $('.onboard-panel').addClass('hidden');
  $('#panel-' + panel).removeClass('hidden');
  $('li.step-' + currentPanel).html("<span class='glyphicon glyphicon-ok'></span>").addClass('filled-circle');
  $('li.step-' + panel).addClass('active-step');
  return true;
};

window.closeModal = function() {
  $('#modal').modal('hide');
};

Helpy.showGrid = function() {
  // Clean up any select-styled links
  $('.settings-link').removeClass('active-settings-link');

  // Hide and show the grid/panels
  $('.settings-grid').removeClass('hidden');
  $('.settings-panel').addClass('hidden');

  $('h2#setting-header').text('Settings');

};

$(document).on('page:change', Helpy.admin);
