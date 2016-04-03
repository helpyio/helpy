var Helpy = Helpy || {};
Helpy.admin = function(){

  $('table.sortable').sortable({
    items: ".item",
    axis: "y",
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
        url: '/admin/content/update_order',
        dataType: 'json',
        data: {object: obj, obj_id: obj_id, row_order_position: position }
      });
    }
  });

  $('.settings-link').off().on('click', function(){
    var showthis = $(this).data("target");
    $(".settings-section").addClass("hidden");
    $('.settings-section.' + showthis).removeClass("hidden");
    return false;

  });

  $(".pick-a-color").pickAColor({
    inlineDropdown: true //display underneath field
  });

};

$(document).on('page:change', Helpy.admin);
