# flare.js [![Build Status](https://travis-ci.org/toddmotto/flare.svg)](https://travis-ci.org/toddmotto/flare)

flare.js, a &lt;1KB unobtrusive event emitter API for Google Universal Analytics. With flare you can easily bind event JSON to a `data-*` attribute, or use `flare.emit()` to fire flares directly. Flare automatically calls `ga('send')` and constructs other properties (and arguments order) so you don't communicate with `ga()` directly. IE8+.

> Remember to drop in Google Analytics beforehand! See [docs](https://developers.google.com/analytics/devguides/collection/analyticsjs/events#crossbrowser) for more.

#### As data-* attribute
Pass in a JSON Object to `data-flare` to bind your event descriptors. Flare binds a `click` event unless a custom event is specified using `data-flare-event=""`:

```html
<!-- defaults to `click` -->
<a href="/promotions" data-flare='{
  "category": "KPI sections",
  "action": "click",
  "label": "Visit the promotions",
  "value": 4
}'>Click me</a>

<!-- uses `mouseover` -->
<a href="/promotions" data-flare-event="mouseover" data-flare='{
  "category": "KPI sections",
  "action": "mouseover",
  "label": "Visit the promotions",
  "value": 4
}'>Click me</a>
```

The `data-flare-event` gets passed into `addEventListener` and `attachEvent`, so ensure the event is valid.

As flare parses JSON from the `data-*` attribute, you can of course use some of the custom Google Universal Analytics properties such as `{ 'page': '/my-new-page' }` and `{ 'nonInteraction': 1 }`:

```html
<a href="/promotions" data-flare='{
  "category": "KPI sections",
  "action": "click",
  "label": "Visit the promotions",
  "value": {
    "page": "/my-new-page"
  }
}'>Click me</a>
```

#### flare.emit()
Emit a custom flare to send to Google Universal Analytics:

```js
flare.emit({
  category: "KPI sections",
  action: "click",
  label: "Visit the promotions",
  value: 4
});
```

Then use within your own logic:

```html
<a href="/promotions" class="promotions">Click me</a>
<script>
document
  .querySelector('.promotions')
  .addEventListener('click', function () {
    // emit a flare
    flare.emit({
      category: "KPI sections",
      action: "click",
      label: "Visit the promotions",
      value: 4
    });
  }, false);
</script>
```

## Installing with Bower

```
bower install flare
```

## Manual installation
Ensure you're using the files from the `dist` directory (contains compiled production-ready code). Ensure you place the script before the closing `</body>` tag.

```html
<body>
  <!-- html above -->
  <script src="dist/flare.js"></script>
  <script>
  // flare module available
  </script>
</body>
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using Gulp.

## Release history

- 1.0.0
  - Initial release
