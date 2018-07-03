//= require codemirror
//= require codemirror/modes/ruby
//= require codemirror/modes/sass
//= require codemirror/modes/shell
//= require codemirror/modes/sql
//= require codemirror/modes/slim
//= require codemirror/modes/nginx
//= require codemirror/modes/markdown
//= require codemirror/modes/javascript
//= require codemirror/modes/http
//= require codemirror/modes/htmlmixed
//= require codemirror/modes/haml
//= require codemirror/modes/xml
//= require codemirror/modes/css
//= require codemirror/modes/yaml
//= require codemirror/modes/slim
//= require codemirror/modes/php
//= require summernote

// Gives us a capitalize method
String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
};

var Helpy = Helpy || {};
Helpy.admin = function(){

  $(".alert").delay(2000).slideUp(500, function(){
      $(".alert").alert('close');
  });

  $('div.sortable').sortable({
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

  // $('.settings-link').off().on('click', function(){
  //   // Clean up any select-styled links
  //   $('.settings-link').removeClass('active-settings-link');
  //
  //   // Hide and show the grid/panels
  //   $('.settings-grid').addClass('hidden');
  //   $('.settings-panel').removeClass('hidden');
  //
  //   var $this = $(this);
  //   var showthis = $this.data('target');
  //   $('a[data-target=' + showthis + ']').addClass('active-settings-link');
  //   $('.settings-section').addClass('hidden');
  //   $('.settings-section.' + showthis).removeClass('hidden');
  //   $('.agent-header').addClass('hidden');
  //   $('h2#setting-header').text('Settings: ' + $this.text().capitalize());
  //   return false;
  // });

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

  // $('.reports-menu-toggle').off().on('click', function(){
  //   var $reports_nav = $('.reports-nav');
  //   if ($reports_nav.is(":visible")) {
  //     $reports_nav.addClass('hidden-xs').addClass('hidden-sm');
  //   } else {
  //     $reports_nav.removeClass('hidden-xs').removeClass('hidden-sm');
  //   }
  //
  // });

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
  // note: breaks back button so removed
  // Helpy.logHistory();

  $('.input-group.date').datepicker({
    format: "yyyy-mm-dd",
    orientation: "auto left",
    autoclose: true,
    todayHighlight: true
  });

  Helpy.initShortcuts();

  $('.change-user-modal').on('shown.bs.modal', function() {
    $('#user_search').focus();
  });

  // Highlight the last clicked view
  $('.nav-item').off().on('click', function(){
    var $this = $(this);
    $('.nav-item').removeClass('nav-active');
    $this.addClass('nav-active');
  });

  // Highlight the last clicked view
  $('.nav-item').on('mouseover', function(){
    var $this = $(this);
    $this.addClass('nav-over');
  });
  // Highlight the last clicked view
  $('.nav-item').on('mouseout', function(){
    var $this = $(this);
    $this.removeClass('nav-over');
  });

  Helpy.ticketMenu();

};

Helpy.ticketMenu = function() {
  // Show/hide ticket menu
  $('.show-ticket-menu').on('click', function(){
    var $ticketNav = $('#admin-left-nav');

    if ($ticketNav.hasClass('open')) {
      $ticketNav.removeClass('open').addClass('hidden-xs').addClass('hidden-sm').removeClass('left-dropdown');
    } else {
      $ticketNav.addClass('open');
      $ticketNav.removeClass('hidden-xs').removeClass('hidden-sm').addClass('left-dropdown');
    }
  });

  $('.show-ticket-menu.open').on('click', function(){
    var $ticketNav = $('#admin-left-nav');

    $ticketNav.removeClass('open');
    $ticketNav.addClass('hidden-xs');
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
  $('#change-user-modal-' + post_id + ' .search_form').submit();
};

$(document).on('page:change', Helpy.admin);
