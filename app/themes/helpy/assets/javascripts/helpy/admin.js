
// Gives us a capitalize method
String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

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
    $('h2#setting-header').text('Settings: ' + $this.text().capitalize());
    return false;

  });

  $('.pick-a-color').pickAColor({
    inlineDropdown: true //display underneath field
  });

  $('input.send-email').off().on('change', function(){
    var chosen = $("input.send-email:radio:checked").val();
    if (chosen === 'true') {
      $('.smtp-settings').removeClass('hidden');
    } else {
      $('.smtp-settings').addClass('hidden');
    }
  });

};

$(document).on('page:change', Helpy.admin);
