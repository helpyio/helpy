// jshint ignore: start

/*! sidr - v2.2.1 - 2016-02-17
 * http://www.berriart.com/sidr/
 * Copyright (c) 2013-2016 Alberto Varela; Licensed MIT */
!function() {
    "use strict";
    function a(a, b, c) {
        var d = new o(b);
        switch (a) {
        case"open":
            d.open(c);
            break;
        case"close":
            d.close(c);
            break;
        case"toggle":
            d.toggle(c);
            break;
        default:
            p.error("Method " + a + " does not exist on jQuery.sidr")
        }
    }
    function b(a) {
        return "status" === a ? h : s[a] ? s[a].apply(this, Array.prototype.slice.call(arguments, 1)) : "function" != typeof a && "string" != typeof a && a ? void q.error("Method " + a + " does not exist on jQuery.sidr") : s.toggle.apply(this, arguments)
    }
    function c(a, b) {
        if ("function" == typeof b.source) {
            var c = b.source(name);
            a.html(c)
        } else if ("string" == typeof b.source && i.isUrl(b.source))
            u.get(b.source, function(b) {
                a.html(b)
            });
        else if ("string" == typeof b.source) {
            var d = "", e = b.source.split(",");
            if (u.each(e, function(a, b) {
                d += '<div class="sidr-inner">' + u(b).html() + "</div>"
            }), b.renaming) {
                var f = u("<div />").html(d);
                f.find("*").each(function(a, b) {
                    var c = u(b);
                    i.addPrefixes(c)
                }), d = f.html()
            }
            a.html(d)
        } else
            null !== b.source && u.error("Invalid Sidr Source");
        return a
    }
    function d(a) {
        var d = i.transitions, e = u.extend({
            name: "sidr",
            speed: 200,
            side: "left",
            source: null,
            renaming: !0,
            body: "body",
            displace: !0,
            timing: "ease",
            method: "toggle",
            bind: "touchstart click",
            onOpen: function() {},
            onClose: function() {},
            onOpenEnd: function() {},
            onCloseEnd: function() {}
        }, a), f = e.name, g = u("#" + f);
        return 0 === g.length && (g = u("<div />").attr("id", f).appendTo(u("body"))), d.supported && g.css(d.property, e.side + " " + e.speed / 1e3 + "s " + e.timing), g.addClass("sidr").addClass(e.side).data({
            speed: e.speed,
            side: e.side,
            body: e.body,
            displace: e.displace,
            timing: e.timing,
            method: e.method,
            onOpen: e.onOpen,
            onClose: e.onClose,
            onOpenEnd: e.onOpenEnd,
            onCloseEnd: e.onCloseEnd
        }), g = c(g, e), this.each(function() {
            var a = u(this), c = a.data("sidr"), d=!1;
            c || (h.moving=!1, h.opened=!1, a.data("sidr", f), a.bind(e.bind, function(a) {
                a.preventDefault(), d || (d=!0, b(e.method, f), setTimeout(function() {
                    d=!1
                }, 100))
            }))
        })
    }
    var e = {};
    e.classCallCheck = function(a, b) {
        if (!(a instanceof b))
            throw new TypeError("Cannot call a class as a function")
    }, e.createClass = function() {
        function a(a, b) {
            for (var c = 0; c < b.length; c++) {
                var d = b[c];
                d.enumerable = d.enumerable ||!1, d.configurable=!0, "value"in d && (d.writable=!0), Object.defineProperty(a, d.key, d)
            }
        }
        return function(b, c, d) {
            return c && a(b.prototype, c), d && a(b, d), b
        }
    }();
    var f, g, h = {
        moving: !1,
        opened: !1
    }, i = {
        isUrl: function(a) {
            var b = new RegExp("^(https?:\\/\\/)?((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.?)+[a-z]{2,}|((\\d{1,3}\\.){3}\\d{1,3}))(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*(\\?[;&a-z\\d%_.~+=-]*)?(\\#[-a-z\\d_]*)?$", "i");
            return b.test(a)?!0 : !1
        },
        addPrefixes: function(a) {
            this.addPrefix(a, "id"), this.addPrefix(a, "class"), a.removeAttr("style")
        },
        addPrefix: function(a, b) {
            var c = a.attr(b);
            "string" == typeof c && "" !== c && "sidr-inner" !== c && a.attr(b, c.replace(/([A-Za-z0-9_.\-]+)/g, "sidr-" + b + "-$1"))
        },
        transitions: function() {
            var a = document.body || document.documentElement, b = a.style, c=!1, d = "transition";
            return d in b ? c=!0 : !function() {
                var a = ["moz", "webkit", "o", "ms"], e = void 0, f = void 0;
                d = d.charAt(0).toUpperCase() + d.substr(1), c = function() {
                    for (f = 0; f < a.length; f++)
                        if (e = a[f], e + d in b)
                            return !0;
                    return !1
                }(), d = c ? "-" + e.toLowerCase() + "-" + d.toLowerCase() : null
            }(), {
                supported: c,
                property: d
            }
        }()
    }, j = jQuery, k = "sidr-animating", l = "open", m = "close", n = "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", o = function() {
        function a(b) {
            e.classCallCheck(this, a), this.name = b, this.item = j("#" + b), this.openClass = "sidr" === b ? "sidr-open" : "sidr-open " + b + "-open", this.menuWidth = this.item.outerWidth(!0), this.speed = this.item.data("speed"), this.side = this.item.data("side"), this.displace = this.item.data("displace"), this.timing = this.item.data("timing"), this.method = this.item.data("method"), this.onOpenCallback = this.item.data("onOpen"), this.onCloseCallback = this.item.data("onClose"), this.onOpenEndCallback = this.item.data("onOpenEnd"), this.onCloseEndCallback = this.item.data("onCloseEnd"), this.body = j(this.item.data("body"))
        }
        return e.createClass(a, [{
            key: "getAnimation",
            value: function(a, b) {
                var c = {}, d = this.side;
                return "open" === a && "body" === b ? c[d] = this.menuWidth + "px" : "close" === a && "menu" === b ? c[d] = "-" + this.menuWidth + "px" : c[d] = 0, c
            }
        }, {
            key: "prepareBody",
            value: function(a) {
                var b = "open" === a ? "hidden": "";
                if (this.body.is("body")) {
                    var c = j("html"), d = c.scrollTop();
                    c.css("overflow-x", b).scrollTop(d)
                }
            }
        }, {
            key: "openBody",
            value: function() {
                if (this.displace) {
                    var a = i.transitions, b = this.body;
                    if (a.supported)
                        b.css(a.property, this.side + " " + this.speed / 1e3 + "s " + this.timing).css(this.side, 0).css({
                            width: b.width(),
                            position: "absolute"
                        }), b.css(this.side, this.menuWidth + "px");
                    else {
                        var c = this.getAnimation(l, "body");
                        b.css({
                            width: b.width(),
                            position: "absolute"
                        }).animate(c, {
                            queue: !1,
                            duration: this.speed
                        })
                    }
                }
            }
        }, {
            key: "onCloseBody",
            value: function() {
                var a = i.transitions, b = {
                    width: "",
                    position: "",
                    right: "",
                    left: ""
                };
                a.supported && (b[a.property] = ""), this.body.css(b).unbind(n)
            }
        }, {
            key: "closeBody",
            value: function() {
                var a = this;
                if (this.displace)
                    if (i.transitions.supported)
                        this.body.css(this.side, 0).one(n, function() {
                            a.onCloseBody()
                        });
                    else {
                        var b = this.getAnimation(m, "body");
                        this.body.animate(b, {
                            queue: !1,
                            duration: this.speed,
                            complete: function() {
                                a.onCloseBody()
                            }
                        })
                    }
            }
        }, {
            key: "moveBody",
            value: function(a) {
                a === l ? this.openBody() : this.closeBody()
            }
        }, {
            key: "onOpenMenu",
            value: function(a) {
                var b = this.name;
                h.moving=!1, h.opened = b, this.item.unbind(n), this.body.removeClass(k).addClass(this.openClass), this.onOpenEndCallback(), "function" == typeof a && a(b)
            }
        }, {
            key: "openMenu",
            value: function(a) {
                var b = this, c = this.item;
                if (i.transitions.supported)
                    c.css(this.side, 0).one(n, function() {
                        b.onOpenMenu(a)
                    });
                else {
                    var d = this.getAnimation(l, "menu");
                    c.css("display", "block").animate(d, {
                        queue: !1,
                        duration: this.speed,
                        complete: function() {
                            b.onOpenMenu(a)
                        }
                    })
                }
            }
        }, {
            key: "onCloseMenu",
            value: function(a) {
                this.item.css({
                    left: "",
                    right: ""
                }).unbind(n), j("html").css("overflow-x", ""), h.moving=!1, h.opened=!1, this.body.removeClass(k).removeClass(this.openClass), this.onCloseEndCallback(), "function" == typeof a && a(name)
            }
        }, {
            key: "closeMenu",
            value: function(a) {
                var b = this, c = this.item;
                if (i.transitions.supported)
                    c.css(this.side, "").one(n, function() {
                        b.onCloseMenu(a)
                    });
                else {
                    var d = this.getAnimation(m, "menu");
                    c.animate(d, {
                        queue: !1,
                        duration: this.speed,
                        complete: function() {
                            b.onCloseMenu()
                        }
                    })
                }
            }
        }, {
            key: "moveMenu",
            value: function(a, b) {
                this.body.addClass(k), a === l ? this.openMenu(b) : this.closeMenu(b)
            }
        }, {
            key: "move",
            value: function(a, b) {
                h.moving=!0, this.prepareBody(a), this.moveBody(a), this.moveMenu(a, b)
            }
        }, {
            key: "open",
            value: function(b) {
                var c = this;
                if (h.opened !== this.name&&!h.moving) {
                    if (h.opened!==!1) {
                        var d = new a(h.opened);
                        return void d.close(function() {
                            c.open(b)
                        })
                    }
                    this.move("open", b), this.onOpenCallback()
                }
            }
        }, {
            key: "close",
            value: function(a) {
                h.opened !== this.name || h.moving || (this.move("close", a), this.onCloseCallback())
            }
        }, {
            key: "toggle",
            value: function(a) {
                h.opened === this.name ? this.close(a) : this.open(a)
            }
        }
        ]), a
    }(), p = jQuery, q = jQuery, r = ["open", "close", "toggle"], s = {}, t = function(b) {
        return function(c, d) {
            "function" == typeof c ? (d = c, c = "sidr") : c || (c = "sidr"), a(b, c, d)
        }
    };
    for (f = 0; f < r.length; f++)
        g = r[f], s[g] = t(g);
    var u = jQuery;
    jQuery.sidr = b, jQuery.fn.sidr = d
}();
