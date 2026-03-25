# jQuery

Use this reference after detecting a jQuery app or a legacy browser app with direct script tags.

## Detect

Check:

- `index.html`
- script tags loading jQuery and app JS
- no stronger framework bootstrap than plain browser scripts

## Minimum setup

Add the Bugfender script tag before the app script:

```html
<script defer src="https://js.bugfender.com/bugfenderjs"></script>
```

Initialize in the HTML page or the main JS file:

```js
Bugfender.init({
  appKey: "{APP_KEY}",
});
```

## Integration points

- page template: `index.html`
- bootstrap: main browser JS file

## Optional capabilities

- Browser overrides and error handling are optional and should only be enabled if requested.

## Verification

Emit one simple log:

```js
Bugfender.log("Bugfender initialized");
```

