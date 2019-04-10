$(document).ready(function () {

    $(".agent-assist").autocomplete({
        source: function (request, response) {
            jQuery.get("/admin/agent_assistant.json", {
                query: request.term
            }, function (data) {
                response(data);
            });
        },
        minLength: 3,
        appendTo: $('assist-results'),
        focus: function (event, ui) {
            event.preventDefault();
            $(this).val(ui.item.name);
        },
        select: function (event, ui) {
            event.preventDefault();
            // set value of summernote with existing value + common reply
            var link = "<a href='" + ui.item.link + "' target='blank'>" + ui.item.name + "</a>";
            $('#post_body').summernote('code', $('#post_body').summernote('code') + link);
            $('#topic_post_body').summernote('code', $('#topic_post_body').summernote('code') + link);
            $('.assist-results').html('').fadeOut();
            $(".agent-assist").val('');
            return false;
        },
        messages: {
            noResults: '',
            results: function () { }
        }

    });



});
