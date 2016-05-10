$('#tickets').html("<%= escape_javascript(render 'admin/ticket') %>");
$('#left-col-ticket-nav').html("<%= escape_javascript(render 'admin/ticket_nav') %>");

// Update timestamps
$('.last-active time[data-time-ago]').timeago();

// jQuery hook
Helpy.ready();
Helpy.track();
