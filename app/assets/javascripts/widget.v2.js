// Uses Widget wrapper provided by lukencode: https://gist.github.com/lukencode/4629345#file-widget-js
// Helpy Widget V2
(function () {

    var helpyDomain = Helpy.domain;
    var helpIcon = Helpy.widgetIcon || Helpy.domain + "/assets/helpy-logo.svg"; // 60x60 round icon, with 6px gutter
    var scriptName = "widget.v2.js"; //name of this script, used to get reference to own tag
    var jQuery; //noconflict reference to jquery
    var jqueryPath = "//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js";
    var jqueryVersion = "1.8.3";
    var scriptTag; //reference to the html script tag

    /******** Get reference to self (scriptTag) *********/
    var allScripts = document.getElementsByTagName('script');
    var targetScripts = [];
    for (var i in allScripts) {
        var name = allScripts[i].src;
        if(name && name.indexOf(scriptName) > 0)
            targetScripts.push(allScripts[i]);
    }

    scriptTag = targetScripts[targetScripts.length - 1];

    /******** helper function to load external scripts *********/
    function loadScript(src, onLoad) {
        var script_tag = document.createElement('script');
        script_tag.setAttribute("type", "text/javascript");
        script_tag.setAttribute("src", src);

        if (script_tag.readyState) {
            script_tag.onreadystatechange = function () {
                if (this.readyState == 'complete' || this.readyState == 'loaded') {
                    onLoad();
                }
            };
        } else {
            script_tag.onload = onLoad;
        }
        (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
    }

    /******** helper function to load external css  *********/
    function loadCss(href) {
        var link_tag = document.createElement('link');
        link_tag.setAttribute("type", "text/css");
        link_tag.setAttribute("rel", "stylesheet");
        link_tag.setAttribute("href", href);
        (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(link_tag);
    }

    /******** load jquery into 'jQuery' variable then call main ********/
    if (window.jQuery === undefined || window.jQuery.fn.jquery !== jqueryVersion) {
        loadScript(jqueryPath, initjQuery);
    } else {
        initjQuery();
    }

    function initjQuery() {
        jQuery = window.jQuery.noConflict(true);
				jQuery(document).ready(main());
    }

    /******** starting point for your widget ********/
    function main() {
      //your widget code goes here

        jQuery(document).ready(function ($) {

          // create widget iframe object
          var $widgetIframe = $('<iframe>', {
                               src: helpyDomain + "/widget",
                               id:  'widget-frame',
                               frameborder: 0,
                               //height: 380,
                               width: 340,
                               scrolling: 'no',
                               class: 'widget-iframe'
                             });

					// Add container for widget
					var $widgetContainer = $('<div class="popout"></div>');
					$widgetContainer.append('<div class="widget-panel hidden"></div>');
					$widgetContainer.append('<div class="btn hidden-xs"><img src="' + helpIcon + '"></div>');

          // Resizer for Iframe
          $('.widget-iframe').on('load', function(){
            this.style.height=this.contentDocument.body.scrollHeight +'px';
          });

					// Add container to page
					$('body').append($widgetContainer);

          // Add Iframe to container;
          $('.widget-panel').append($widgetIframe);

          // Reload iframe
          document.getElementById('widget-frame').contentWindow.location.reload();

					// add listeners

					$(".popout .btn").off().on('click', function(e){

            // reload the iframe content
            $widgetIframe.attr('src', helpyDomain + "/widget");

						$(this).toggleClass("active");
						$(this).closest(".popout").find(".widget-panel").toggleClass("active").removeClass("hidden");

						var $button = $('.popout .btn');
						var $modal = $('.popout .widget-panel');
						var top = $button.position().top + $button.height() + (($button.outerHeight(true) - $button.height()));

						$(".popout").css({"top": top-$modal.height()});

						console.log($button.css('top'));
						console.log(top);
						console.log($modal.height());

						e.stopPropagation();
					});

					$(document).click(function(){
						$(".popout .widget-panel").removeClass("active");
            $(".widget-panel").addClass("hidden");
						$(".popout .btn").removeClass("active");
					});

					$(".popout .widget-panel").click(function(event){
						event.stopPropagation();
					});

					$(".popout .btn").click(function(event){
						event.stopPropagation();
					});

          // Load widget styles
          loadCss(helpyDomain + "/assets/widget.v1.css");
        });

    }

})();
