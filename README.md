# Privatus Analytics for Micro.blog

**See how many real people read your blog. No cookies, no cookie pop-up, no bots.**

You write a post and want to know if anyone read it. Most analytics tools use
cookies. In many countries that means you must show a cookie pop-up first (a
box that asks visitors to say yes to cookies). Lots of people click no, so they
never show up in your numbers. Bots add fake visits on top.

This Micro.blog plug-in adds Privatus Analytics to every page of your blog.
You paste one site ID and you are done. The script sets no cookies and keeps
no IP addresses. Bots are left out before they are counted.

So you see how many real people came, which posts they read and where they
came from, on one simple dashboard. A report comes to your inbox each week.

**Free plan, no card:** 10,000 events a month (an event is a page view or an
action you track) on up to 3 sites.
[Start free at privatusanalytics.com](https://privatusanalytics.com).

- **No cookies.** No cookies and no hidden IDs on your readers' devices, and no
  IP addresses are kept. Laws differ by country, so check your own legal advice.
- **Real people, not bots.** Known bots, data centers and spam visits are left
  out on every plan.
- **Small and fast.** The script is about 3 KB when compressed.

## Install

1. Sign up at [privatusanalytics.com](https://privatusanalytics.com) and add
   your blog's address (for example `yourname.micro.blog`, or your own domain).
2. Copy your site ID. It starts with `pa_`. You find it in Privatus Analytics
   under Site settings, Tracking.
3. In Micro.blog, go to **Design**, then **Plug-ins**, then **Find Plug-ins**.
   Search for **Privatus Analytics** and click **Install**.
4. Click **Plug-in settings**, paste your site ID and click **Update Settings**.

Micro.blog rebuilds your blog. Open it in a new browser window, then look at
the Live view in Privatus Analytics. Your visit shows up within a few seconds.

Made your own theme? Plug-ins need the `microblog_head.html` partial that
Micro.blog themes load inside `<head>`. All built-in themes have it.

## Settings

| Setting | What it does |
| --- | --- |
| Site ID | Your Privatus Analytics site ID, like `pa_ABC123`. Nothing is added to your blog until this is set. If it is not a valid ID, nothing is added. |
| Extra features | A list split by commas. The default is `engage,auto,vitals,clicks,ask`. Clear it to count page views only. |
| Pages not to count (optional) | Paths to leave out, split by commas. A `*` matches anything, for example `/drafts/*`. |

What the extra features do:

- `engage`: how long people read and how far they scroll.
- `auto`: counts outbound links, file downloads and form sends by itself.
- `vitals`: page speed as your readers feel it.
- `clicks`: shows where people click.
- `ask`: lets you show short surveys you set up in Privatus Analytics.

## Track your own events

Have a sign-up form or a button in a post? You can count it. Add a
`data-privatus-event` attribute to a link or button:

```html
<a href="https://example.com/newsletter" data-privatus-event="Newsletter clicked">Join my newsletter</a>
```

Or call the tracker from your own script:

```js
window.privatus && window.privatus.track("Newsletter clicked", { place: "footer" });
```

See [privatusanalytics.com/docs](https://privatusanalytics.com/docs) for more.

## What it adds to your pages

One line inside `<head>`:

```html
<script defer src="https://privatusstats.com/js/pa.js" data-site="pa_YOURSITEID" data-modules="engage,auto,vitals,clicks,ask"></script>
```

## Development

The plug-in is a small Hugo partial (`layouts/partials/privatus-analytics.html`).
`plugin.json` tells Micro.blog what to show on the settings screen, and
`config.json` holds the default settings.

Tests build a test blog with Hugo in Docker, with the plug-in installed as a
theme the way Micro.blog does it:

```sh
docker run --rm -v "$PWD:/project" --entrypoint sh klakegg/hugo:0.91.2-alpine /project/tests/run.sh
docker run --rm -v "$PWD:/project" --entrypoint sh ghcr.io/gohugoio/hugo:v0.167.0 /project/tests/run.sh
```

## Help

Email [hello@privatusanalytics.com](mailto:hello@privatusanalytics.com) or open
an issue on this repository.

## License

MIT, see [LICENSE](LICENSE). Copyright Two Phase LLC.
