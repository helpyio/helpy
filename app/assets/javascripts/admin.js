
/* mousetrap v1.6.0 craig.is/killing/mice */
(function(r,t,g){function u(a,b,h){a.addEventListener?a.addEventListener(b,h,!1):a.attachEvent("on"+b,h)}function y(a){if("keypress"==a.type){var b=String.fromCharCode(a.which);a.shiftKey||(b=b.toLowerCase());return b}return k[a.which]?k[a.which]:p[a.which]?p[a.which]:String.fromCharCode(a.which).toLowerCase()}function D(a){var b=[];a.shiftKey&&b.push("shift");a.altKey&&b.push("alt");a.ctrlKey&&b.push("ctrl");a.metaKey&&b.push("meta");return b}function v(a){return"shift"==a||"ctrl"==a||"alt"==a||
"meta"==a}function z(a,b){var h,c,e,g=[];h=a;"+"===h?h=["+"]:(h=h.replace(/\+{2}/g,"+plus"),h=h.split("+"));for(e=0;e<h.length;++e)c=h[e],A[c]&&(c=A[c]),b&&"keypress"!=b&&B[c]&&(c=B[c],g.push("shift")),v(c)&&g.push(c);h=c;e=b;if(!e){if(!n){n={};for(var l in k)95<l&&112>l||k.hasOwnProperty(l)&&(n[k[l]]=l)}e=n[h]?"keydown":"keypress"}"keypress"==e&&g.length&&(e="keydown");return{key:c,modifiers:g,action:e}}function C(a,b){return null===a||a===t?!1:a===b?!0:C(a.parentNode,b)}function c(a){function b(a){a=
a||{};var b=!1,m;for(m in n)a[m]?b=!0:n[m]=0;b||(w=!1)}function h(a,b,m,f,c,h){var g,e,k=[],l=m.type;if(!d._callbacks[a])return[];"keyup"==l&&v(a)&&(b=[a]);for(g=0;g<d._callbacks[a].length;++g)if(e=d._callbacks[a][g],(f||!e.seq||n[e.seq]==e.level)&&l==e.action){var q;(q="keypress"==l&&!m.metaKey&&!m.ctrlKey)||(q=e.modifiers,q=b.sort().join(",")===q.sort().join(","));q&&(q=f&&e.seq==f&&e.level==h,(!f&&e.combo==c||q)&&d._callbacks[a].splice(g,1),k.push(e))}return k}function g(a,b,m,f){d.stopCallback(b,
b.target||b.srcElement,m,f)||!1!==a(b,m)||(b.preventDefault?b.preventDefault():b.returnValue=!1,b.stopPropagation?b.stopPropagation():b.cancelBubble=!0)}function e(a){"number"!==typeof a.which&&(a.which=a.keyCode);var b=y(a);b&&("keyup"==a.type&&x===b?x=!1:d.handleKey(b,D(a),a))}function k(a,c,m,f){function e(c){return function(){w=c;++n[a];clearTimeout(r);r=setTimeout(b,1E3)}}function h(c){g(m,c,a);"keyup"!==f&&(x=y(c));setTimeout(b,10)}for(var d=n[a]=0;d<c.length;++d){var p=d+1===c.length?h:e(f||
z(c[d+1]).action);l(c[d],p,f,a,d)}}function l(a,b,c,f,e){d._directMap[a+":"+c]=b;a=a.replace(/\s+/g," ");var g=a.split(" ");1<g.length?k(a,g,b,c):(c=z(a,c),d._callbacks[c.key]=d._callbacks[c.key]||[],h(c.key,c.modifiers,{type:c.action},f,a,e),d._callbacks[c.key][f?"unshift":"push"]({callback:b,modifiers:c.modifiers,action:c.action,seq:f,level:e,combo:a}))}var d=this;a=a||t;if(!(d instanceof c))return new c(a);d.target=a;d._callbacks={};d._directMap={};var n={},r,x=!1,p=!1,w=!1;d._handleKey=function(a,
c,e){var f=h(a,c,e),d;c={};var k=0,l=!1;for(d=0;d<f.length;++d)f[d].seq&&(k=Math.max(k,f[d].level));for(d=0;d<f.length;++d)f[d].seq?f[d].level==k&&(l=!0,c[f[d].seq]=1,g(f[d].callback,e,f[d].combo,f[d].seq)):l||g(f[d].callback,e,f[d].combo);f="keypress"==e.type&&p;e.type!=w||v(a)||f||b(c);p=l&&"keydown"==e.type};d._bindMultiple=function(a,b,c){for(var d=0;d<a.length;++d)l(a[d],b,c)};u(a,"keypress",e);u(a,"keydown",e);u(a,"keyup",e)}if(r){var k={8:"backspace",9:"tab",13:"enter",16:"shift",17:"ctrl",
18:"alt",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"ins",46:"del",91:"meta",93:"meta",224:"meta"},p={106:"*",107:"+",109:"-",110:".",111:"/",186:";",187:"=",188:",",189:"-",190:".",191:"/",192:"`",219:"[",220:"\\",221:"]",222:"'"},B={"~":"`","!":"1","@":"2","#":"3",$:"4","%":"5","^":"6","&":"7","*":"8","(":"9",")":"0",_:"-","+":"=",":":";",'"':"'","<":",",">":".","?":"/","|":"\\"},A={option:"alt",command:"meta","return":"enter",
escape:"esc",plus:"+",mod:/Mac|iPod|iPhone|iPad/.test(navigator.platform)?"meta":"ctrl"},n;for(g=1;20>g;++g)k[111+g]="f"+g;for(g=0;9>=g;++g)k[g+96]=g;c.prototype.bind=function(a,b,c){a=a instanceof Array?a:[a];this._bindMultiple.call(this,a,b,c);return this};c.prototype.unbind=function(a,b){return this.bind.call(this,a,function(){},b)};c.prototype.trigger=function(a,b){if(this._directMap[a+":"+b])this._directMap[a+":"+b]({},a);return this};c.prototype.reset=function(){this._callbacks={};this._directMap=
{};return this};c.prototype.stopCallback=function(a,b){return-1<(" "+b.className+" ").indexOf(" mousetrap ")||C(b,this.target)?!1:"INPUT"==b.tagName||"SELECT"==b.tagName||"TEXTAREA"==b.tagName||b.isContentEditable};c.prototype.handleKey=function(){return this._handleKey.apply(this,arguments)};c.addKeycodes=function(a){for(var b in a)a.hasOwnProperty(b)&&(k[b]=a[b]);n=null};c.init=function(){var a=c(t),b;for(b in a)"_"!==b.charAt(0)&&(c[b]=function(b){return function(){return a[b].apply(a,arguments)}}(b))};
c.init();r.Mousetrap=c;"undefined"!==typeof module&&module.exports&&(module.exports=c);"function"===typeof define&&define.amd&&define(function(){return c})}})("undefined"!==typeof window?window:null,"undefined"!==typeof window?document:null);

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

  Mousetrap.bind('s r', function() {
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
