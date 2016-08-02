$('#results-found').html("<%= escape_javascript(render('results_found')) %>");
$('#search-results').html("<%= escape_javascript(render('search_results')) %>");
// Need to report search to google here too

// Send ping to GA
ga('send', 'pageview', '/results/?q=<%= params[:q] %>');

Helpy.ready();
Helpy.track();
