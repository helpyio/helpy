// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require best_in_place
//= require jquery_ujs
//= require jquery-fileupload
//= require bootstrap-sprockets
//= require turbolinks
//= require jquery.turbolinks
//= require js-cookie/src/js.cookie.js
// require_tree .
//= require event-tracking
//= require twitter/bootstrap/rails/confirm
//= require bootstrap-icon-chooser/js/iconPicker
//= require rails-timeago-all
//= require flare/dist/flare
//= require cloudinary
//= require attachinary
//= require magnific-popup/dist/jquery.magnific-popup.min.js
//= require initial.js/initial.js
//= require autolink/autolink-min.js
//= require jquery.minicolors
//= require app
//= require rails.validations
//= require rails.validations.simple_form
//= require rails.validations.callbacks
//= require selectize
//= require bootstrap-switch
//= require bootstrap-datepicker
//= require bootstrap-select
//= require bootstrap/alert
//= require bootstrap/dropdown
//= require Chart.bundle
//= require chartkick
//= require sisyphus.min.js

// Jtruncate plugin, http://www.jeremymartin.name/projects.php?project=jTruncate
// modified by Scott Miller- remove animation, newline for more link

(function($){
  $.fn.jTruncate = function(opts) {
    var defaults = {
      length: 300,
      minTrail: 20,
      moreText: "more",
      lessText: "less",
      ellipsisText: "..."
    };

    var options = $.extend(defaults, opts);

    return this.each(function() {
      obj = $(this);
      var body = obj.html();

      if(body.length > options.length + options.minTrail) {
        var splitLocation = body.indexOf(' ', options.length);
        if(splitLocation != -1) {
          // truncate tip
          var str1 = body.substring(0, splitLocation);
          var str2 = body.substring(splitLocation, body.length - 1);
          obj.html(str1 + '<span class="truncate_ellipsis">' + options.ellipsisText +
            '</span>' + '<span class="truncate_more">' + str2 + '</span>');
          obj.find('.truncate_more').css("display", "none");

          // insert more link
          $('<a href="#" class="truncate_more_link">' + options.moreText + '</a>').insertAfter(obj.find('.truncate_more'));
        }
      } // end if

    });
  };
})(jQuery);

// set onclick event for more/less link
$(document).on("click", '.truncate_more_link', function(){
  var options = {
    length: 300,
    minTrail: 20,
    moreText: " (more)",
    lessText: " (less)",
    ellipsisText: "..."
  };

  var obj = $(this).parent().parent(".shorten");

  var moreLink = $('.truncate_more_link', obj);
  var moreContent = $('.truncate_more', obj);
  var ellipsis = $('.truncate_ellipsis', obj);
  if(moreLink.text() == options.moreText) {
    moreContent.show();
    moreLink.text(options.lessText);
    ellipsis.css("display", "none");
  } else {
    moreContent.hide();
    moreLink.text(options.moreText);
    ellipsis.css("display", "inline");
  }
  return false;

});
