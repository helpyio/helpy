var Helpy = Helpy || {};
Helpy.track = function(){

  // Put the Google Analytics clientID into the Helpy data layer
  ga(function(tracker) {
    Helpy.clientId = tracker.get('clientId');

    // Do some more stuff here if you want...
  });

  // Search Events

  $('#page-title').find('#search-form').unbind().on('submit', function(){
    ga('send', 'event', 'Search','Search', 'Header Search');
    ga('send', 'event', 'Search','Search', $('#search-field').val());
  });

  $('#home-search').find('#search-form').unbind().on('submit', function(){
    ga('send', 'event', 'Search','Search', 'Home Page');
    ga('send', 'event', 'Search','Search', $('#search-field').val());
  });


  $('.search-result > span > a').unbind().on('click', function(){
    ga('send', 'event', 'Results','Click', $('#search-field').val());
  });


  // main navigation events

  $('.navbar-brand').unbind().on('click', function(){
    ga('send', 'event', 'Main Nav','Click', 'Logo');
  });

//  $('.navbar-nav > li > a, #above-header > small > a').on('click', function(){
//    console.log('Clicked ' + $(this).text())
//    ga('send', 'event', 'Main Nav','Click', $(this).text())
//  });

  $('.get-help-button').on('click', function(){
    ga('send', 'event', 'Main Nav','Click', $(this).text());
  });

  $('.breadcrumb > li > a').unbind().on('click', function(){
    ga('send', 'event', 'Main Nav','Click', "Breadcrumb: " + $(this).text());
  });


  // Inpage events: Inpage events represent things that happen on the page but
  // do not involve global navigation

  $('.label-collapsed').off().on("click", function(){
    ga('send', 'event', 'Inpage-Nav','Click', 'Show Hidden');
  });

  $('.topic-box').on("click", function(){
    ga('send', 'event', 'Inpage-Nav','Click', $(this).find('h5').text());
  });

  // Discussion Click
  $('tr.forum').find('a').off().on('click', function(){
    ga('send', 'event', 'Inpage-nav','Click', "Forum: " + $(this).text());
  });

  $('.topic-link').find('a').off().on('click', function(){
    ga('send', 'event', 'Inpage-nav','Click', "Topic: " + $(this).text());
  });

  $('.user-link').find('a').off().on('click', function(){
    ga('send', 'event', 'Inpage-nav','Click', "User: " + $(this).text());
  });

  // Same page links: links which scroll the page or repesent some other
  // interaction on the page
  $('.autoscroll').off().on("click", function(){
    ga('send', 'event', 'Same-Page-Nav','Click', $(this).text());
  });

  // Voting Events
  $('#did-this-help-no').off().on("click", function(){
    Helpy.didthisHelp("no");
    ga('send', 'event', 'Feedback','No', $('#page-title h1').text());
  });

  $('#did-this-help-yes').off().on("click", function(){
    Helpy.didthisHelp("yes");
    ga('send', 'event', 'Feedback','Yes', $('#page-title h1').text());
  });

  // Post and Topic voting.
  // YOU MAY WANT TO DISABLE THIS IF YOU RUN A BUSY SITE
  // AS IT COULD EXCEED YOUR EVENT TRACK LIMIT IN GA

  $('.post-vote').off().on("click", function(){
    var $voted = $(this).data("voted");
    ga('send', 'event', 'Vote','Post', $voted);
  });

  $('.topic-vote').off().on("click", function(){
    var $voted = $(this).data("voted");
    ga('send', 'event', 'Vote','Topic', $voted);
  });

  // OAuth Click Events
  $('.oauth').off().on("click", function(){
    var $provider = $(this).data("provider");
    ga('send', 'event', 'oauth','provider', $provider);
  });



    // document.location.href = $(this).data("link");

  // User created a new ticket/discussion
  // Handled on server side with GA MP




};

$(document).on('page:change', Helpy.track);
