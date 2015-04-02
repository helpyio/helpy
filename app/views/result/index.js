$('#results-found').html("<h4><span id='results-total-count'><%= @results.total_count %></span> results found for your search for <strong><%= params[:q] %></strong></h4>")
$('#search-results').html("<%= escape_javascript(render('search_results')) %>");
