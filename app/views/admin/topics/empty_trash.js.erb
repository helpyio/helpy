$('#tickets').html("<%= escape_javascript(render 'admin/topics/tickets') %>");
$('.ticket-stats').html("<%= j render 'admin/topics/ticket_stats' %>");
$('#user-info').html("<%= j render 'admin/users/user_info_horizontal' if @user %>");
// $('#ticket-page-title').show().html("<%= t(:discussions, default: 'Discussions') %>: <% ticket_page_title %>");
$(document).prop('title', "<%= admin_title %> <%= t(:discussions, default: 'Discussions') %>: <%= @status.titleize if @status %>");
history.pushState(null, null, '<%= admin_topics_path(status: "active") %>');

Helpy.current_status_view = '<%= @status %>';
Helpy.current_page_view = '<%= params[:page] %>';
Helpy.current_box_id = '<%= @box.present? ? @box.id : '' %>';

// Empty ticket search field and show
$('#q').val('');

// Update timestamps
$('.last-active time[data-time-ago]').timeago();

// Send ping to GA
ga('send', 'pageview');

// jQuery hook
Helpy.ready();
Helpy.track();
Helpy.logHistory();
Helpy.ticketMenu();

// RTL changes?
<%= "Helpy.rtl();" if rtl? %>

// Update bootstrap_flash
$('.flash-wrapper').html("<%= j bootstrap_flash %>");
// Autoclose alert messages in admin
$(".alert").delay(5000).slideUp(500, function(){
    $(".alert").alert('close');
});
<% flash[:notice] = '' %>