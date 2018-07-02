Helpy.showShortcuts = function() {
  if ($('#shortcutmodal').size() === 0) {
    $('body').append("<div id='shortcutmodal' class=\"modal\" tabindex=\"-1\" role=\"dialog\" data-backdrop=\"static\">" +
        "<div class=\"modal-dialog modal-lg\">" +
        "	<div class=\"modal-content\">" +
        "		<iframe src=\"/admin/shortcuts\" width=\"100%\" height=\"900\" frameborder=\"no\" scrolling=\"auto\"></iframe>" +
        "	</div>" +
        "</div>" +
      "</div>");
  }
  $('#shortcutmodal').modal();
  return false;
};

Helpy.initShortcuts = function() {

  // Keyboard Shortcut definition

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
    $('.new-discussion a').click();
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
  // m - move to forum
  // x - expand thread
  // r - reply
  // o - note
  // u - show status menu
  // g - group menu

  Mousetrap.bind('a', function() {
    $('.assign-to').click();
  });
  Mousetrap.bind('m', function() {
    $('.privacy-toggle').click();
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
    // startTopic is where the list selector starts out- either first or the selected one
    var $startingTopic;
    if ($('.tiny-topic-active').length > 0) {
      $startingTopic = $('.tiny-topic-active').first();
    } else {
      $startingTopic = $('.topic').first();
    }

    if ($('.selected').size() === 0) {
      $startingTopic.addClass('selected');
      // $('.topic').first().addClass('selected');
      pressEnter($('.topic').first().find('a.topic-link'));
    } else {
      var $nowSelected = $('.selected').next('.topic');

      $nowSelected.addClass('selected');
      $currentSelected.removeClass('selected');
      pressEnter($nowSelected.find('a.topic-link'));
    }
  });

  Mousetrap.bind(',', function() {
    var $currentSelected = $('.selected');
    // startTopic is where the list selector starts out- either first or the selected one
    var $startingTopic;
    if ($('.tiny-topic-active').length > 0) {
      $startingTopic = $('.tiny-topic-active').first();
    } else {
      $startingTopic = $('.topic').last();
    }

    if ($('.selected').size() === 0) {
      $startingTopic.addClass('selected');
      pressEnter($('.topic').last().find('a.topic-link'));
    } else {
      var $nowSelected = $('.selected').prev('.topic');
      $nowSelected.addClass('selected');
      $currentSelected.removeClass('selected');
      pressEnter($nowSelected.find('a.topic-link'));
    }
  });

  // Show help screen
  Mousetrap.bind('?', function() {
    Helpy.showShortcuts();
  });
};
