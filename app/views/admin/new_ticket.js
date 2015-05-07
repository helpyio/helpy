$('#tickets').html("<%= escape_javascript(render 'new_ticket') %>");
$('#left-col-ticket-nav').html("<%= escape_javascript(render 'ticket_nav') %>");
$('#ticket-page-title').html("Discussion Management: New Discussion");
$(document).prop('title', "Discussion Management: New Discussion");
window.location.hash = 'new';

// Empty ticket search field
$('q').val();

// Update timestamps
$('.last-active time[data-time-ago]').timeago();

// Send ping to GA
ga('send', 'pageview');

// jQuery hook
Helpy.ready();
Helpy.track();
