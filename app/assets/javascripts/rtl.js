// This is to convert some of the Bootstrap constructs to rtl
var Helpy = Helpy || {};
Helpy.rtl = function(){

  var $pullLefts = $('.pull-left');
  var $pullRights = $('.pull-right');

  $('.navbar-right').removeClass('navbar-right').addClass('navbar-left');
  $('.menu-left').removeClass('menu-left').addClass('menu-right');
  $('.text-right').removeClass('text-right').addClass('text-left');
  $pullRights.removeClass('pull-right').addClass('pull-left');
  $pullLefts.removeClass('pull-left').addClass('pull-right');
  $('.logo').removeClass('pull-left').addClass('pull-right');
  $('.dropdown-menu-right').removeClass('dropdown-menu-right').addClass('dropdown-menu-left');
  $('#status-mobile-dropdown .dropdown-menu').addClass('dropdown-menu-left');


  $('.topic .status-label').css('float','right');
  $('.label-count, .topic-checkbox').css('float','right');
  $('.media-body .last-active,.media-body .less-important').css('text-align', 'left');
  $('.media-body .post-body ').css('text-align','right');
  $('.media-body .posted-at ').css('float','right');
};

$(document).on('page:change', Helpy.rtl);
