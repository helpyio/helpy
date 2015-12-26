
// var HelpyWidget = HelpyWidget || {}
// HelpyWidget.domain = "http://localhost:3000/"

// Uses Widget wrapper provided by lukencode: https://gist.github.com/lukencode/4629345#file-widget-js

(function () {

    var scriptName = "widget.v1.js"; //name of this script, used to get reference to own tag
    var jQuery; //noconflict reference to jquery
    var jqueryPath = "http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js";
    var jqueryVersion = "1.8.3";
    var scriptTag; //reference to the html script tag

    /******** Get reference to self (scriptTag) *********/
    var allScripts = document.getElementsByTagName('script');
    var targetScripts = [];
    for (var i in allScripts) {
        var name = allScripts[i].src
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
//        main();

				$(document).ready(main());
				$(document).on('page:load', main());

    }

    /******** starting point for your widget ********/
    function main() {
      //your widget code goes here

        jQuery(document).ready(function ($) {

					// Add container for widget
					var $widgetContainer = $('<div class="popout"></div>');
					$widgetContainer.append('<div class="widget-panel"><iframe src="http://localhost:3000/widget/" height="400" width="340" scrolling="no" frameborder="0"></div>');
					$widgetContainer.append('<div class="btn"><i class="icon glyphicon glyphicon-question-sign"></i></div>');

					// Add container to page
					$('body').append($widgetContainer);

					//$(".widget-panel").html('<iframe src="http://localhost:3000/widget/" height="600" width="340" scrolling="no" frameborder="0">');



					// add listeners
					$(".popout .btn").off().on('click', function(e){
						$(this).toggleClass("active");
						$(this).closest(".popout").find(".widget-panel").toggleClass("active");

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
						$(".popout .btn").removeClass("active");
					});

					$(".popout .widget-panel").click(function(event){
						event.stopPropagation();
					});

					$(".popout .btn").click(function(event){
						event.stopPropagation();
					});

          loadCss("http://localhost:3000/assets/widget.css");

          //example script load
          //loadScript("http://example.com/anotherscript.js", function() { /* loaded */ });
        });

    }

})();
