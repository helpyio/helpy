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
    $('.agent-header').addClass('hidden');
    $('h2#setting-header').text('Settings: ' + $this.text().capitalize());
    return false;
  });

  // You have to delegate this to the document or it does not work reliably
  // See http://stackoverflow.com/questions/18545941/jquery-on-submit-event
  $(document).off('submit','form.new-group-form').on('submit','form.new-group-form', function(){
      var $field = $('#new_group');
      var newGroup = $field.val();
      var $newItem = $('<li/>');
      var $newLink = $('<a class="link-tag" data-remote="true" href="/admin/topics/assign_team?team=' + newGroup + '&topic_ids[]=' + Helpy.topicID + '"><div class="color-sample label-' + newGroup.charAt(0).toLowerCase() + '"></div> <div>' + newGroup + '</div></a></li>');
      $('.new-tag').before($newItem.append($newLink));
      $('#new_group').val('');
      $('.link-tag').off().click();
      return false;
  });

  $('.pick-a-color').minicolors({
    theme: 'bootstrap'
  });

  $('.bs-toggle').bootstrapSwitch();

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

  $('.settings-uploader').off().on('change', function(){
    var $this = $(this);
    var f = $this.val().split("\\");
    var filename = f[f.length-1];
    $('.hidden-header-logo').val("/uploads/logos/" + filename);
  });

  $('.favicon-uploader').off().on('change', function(){
    var $this = $(this);
    var f = $this.val().split("\\");
    var filename = f[f.length-1];
    $('.hidden-favicon').val("/uploads/logos/" + filename);
  });

  // Start logging history from first pageload
  Helpy.logHistory();

  $('.input-group.date').datepicker({
    format: "yyyy-mm-dd",
    orientation: "auto left",
    autoclose: true,
    todayHighlight: true
  });

  // Initiate KB Shortcuts


  // pipeline and search
  // g n - show new tickets
  // g a - show all tickets
  // g o - show open tickets
  // g m - show my tickets
  // g p - show pending
  // g c - show closed messages
  // n - create new ticket
  // f - universal search

  Mousetrap.bind('g n', function() {
    $('.pipeline-new').click();
  });
  Mousetrap.bind('g a', function() {
    $('.pipeline-active').click();
  });
  Mousetrap.bind('g o', function() {
    $('.pipeline-open').click();
  });
  Mousetrap.bind('g m', function() {
    $('.pipeline-mine').click();
  });
  Mousetrap.bind('g p', function() {
    $('.pipeline-pending').click();
  });
  Mousetrap.bind('g c', function() {
    $('.pipeline-closed').click();
  });
  Mousetrap.bind('n', function() {
    $('.new-discussion').click();
  });
  Mousetrap.bind('f', function() {
    $('.topic-search').show();
    $('.search-field').focus();
    return false;
  });
  form = document.getElementById('search-form');
  Mousetrap(form).bind('escape', function(e, combo) {
    $('.search-field').blur();
  });
  newpost = document.getElementById('new_post');
  Mousetrap(newpost).bind('escape', function(e, combo) {
    $('#post_body').blur();
  });
  newtopic = document.getElementById('new_topic');
  Mousetrap(newtopic).bind('escape', function(e, combo) {
    $('#topic_user_email, #topic_user_name, #topic_name, #topic_post_body').blur();
  });

  Mousetrap.bind('t n', function() {
    $('.new-discussion').click();

  });


  // Ticket View
  // a - show assign menu
  // x - expand thread
  // r - reply
  // o - note
  // u - show status menu
  // g - group menu

  Mousetrap.bind('a', function() {
    $('.assign-to').click();
  });
  Mousetrap.bind('p', function() {
    $('.group-to').click();
  });
  Mousetrap.bind('x', function() {
    $('.label-collapsed').click();
  });
  Mousetrap.bind('u', function() {
    $('.change-status').click();
  });
  Mousetrap.bind('r', function() {
    $('#post_body').focus();
    return false;
  });
  Mousetrap.bind('o', function() {
    $('#post_kind_note').click();
    $('#post_body').focus();
    return false;
  });


  // Change status of ticket
  // s r - mark resolved
  // s o - reopen
  // s n - mark new
  // s s - mark spam
  // s t - mark trash

  Mousetrap.bind(['s r','s c'], function() {
    $('.key-sr').click();
  });
  Mousetrap.bind('s o', function() {
    $('.key-so').click();
  });
  Mousetrap.bind('s n', function() {
    $('.key-sn').click();
  });
  Mousetrap.bind('s s', function() {
    $('.key-ss').click();
  });
  Mousetrap.bind('s t', function() {
    $('.key-st').click();
  });

  // Select tickets

  var pressEnter = function($link) {
    Mousetrap.unbind('enter');
    Mousetrap.bind('enter', function(){
      $link.click();
    });
  };

  Mousetrap.bind('.', function() {
    var $currentSelected = $('.selected');

    if ($('.selected').size() == 0) {
      $('.topic').first().addClass('selected');
      pressEnter($('.topic').first().find('a.topic-link'));
    } else {
      var $nowSelected = $('.selected').next('tr.topic');

      $nowSelected.addClass('selected');
      $currentSelected.removeClass('selected');
      pressEnter($nowSelected.find('a.topic-link'));
    }
  });

  Mousetrap.bind(',', function() {
    var $currentSelected = $('.selected');

    if ($('.selected').size() == 0) {
      $('.topic').last().addClass('selected');
      pressEnter($('.topic').last().find('a.topic-link'));
    } else {
      var $nowSelected = $('.selected').prev('tr.topic');
      $nowSelected.addClass('selected');
      $currentSelected.removeClass('selected');
      pressEnter($nowSelected.find('a.topic-link'));
    }
  });

  // Show help screen
  Mousetrap.bind('?', function() {

    if ($('#shortcutmodal').size() == 0) {
      $('body').append(" \
        <div id='shortcutmodal' class=\"modal\" tabindex=\"-1\" role=\"dialog\" data-backdrop=\"static\"> \
      		<div class=\"modal-dialog modal-lg\"> \
      			<div class=\"modal-content\"> \
      				<iframe src=\"/admin/shortcuts\" width=\"100%\" height=\"900\" frameborder=\"no\" scrolling=\"no\"></iframe> \
      			</div> \
      		</div> \
      	</div>");
    };
    $('#shortcutmodal').modal();
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

// Enables correct URL in browser, history
Helpy.logHistory = function() {
  $('a').on('click', function(){
    var url = $(this).attr('href');
    console.log("Clicked: " + url);
    history.pushState(null, '', url);
  });

  $(window).off().on("popstate", function(){
    console.log("Popstate fired: " + location.href);
    $.getScript(location.href);
  });
};

var search_user = function(post_id) {
  $('#change-user-modal-' + post_id + ' form').submit();
};

$(document).on('page:change', Helpy.admin);
