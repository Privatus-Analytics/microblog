#!/bin/sh
# Installs the plug-in the way Micro.blog does (as a theme next to the blog's
# own theme, with config.json as the defaults), builds a test blog with
# different settings and checks the <head>. Runs inside a Hugo Docker image.
set -eu
root="$(cd "$(dirname "$0")/.." && pwd)"
site="$root/tests/site"
plugin="$site/themes/privatus-analytics"
rm -rf "$site/themes" && mkdir -p "$plugin"
cp -R "$root/layouts" "$root/config.json" "$root/plugin.json" "$plugin/"
cd "$site"
fail=0
check() { # name, expected (fixed string), "absent" to expect no match
  if [ "${3:-}" = absent ]; then
    if grep -qF -- "$2" public/index.html; then echo "FAIL $1: found $2"; fail=1; else echo "ok   $1"; fi
  else
    if grep -qF -- "$2" public/index.html; then echo "ok   $1"; else echo "FAIL $1: missing $2"; grep -i privatus public/index.html || true; fail=1; fi
  fi
}
build() { rm -rf public; hugo --quiet --config "$1"; }

echo "Hugo: $(hugo version)"

build hugo.toml
check "no site id prints nothing" 'privatusstats.com' absent

build hugo.toml,../cases/valid.toml
check "default features from config.json" '<script defer src="https://privatusstats.com/js/pa.js" data-site="pa_Blog123" data-modules="engage,auto,vitals,clicks,ask"></script>'

build hugo.toml,../cases/custom.toml
check "custom features and excluded pages" '<script defer src="https://privatusstats.com/js/pa.js" data-site="pa_Custom9" data-modules="engage,vitalsscriptalertscript" data-exclude="/drafts/*&#34; onload=&#34;alert(1)"></script>'
check "no injected attributes" 'onload="' absent
check "no injected tags" '<script>alert' absent

build hugo.toml,../cases/nomodules.toml
check "empty features list" 'data-site="pa_NoMods1" data-modules=""></script>'

build hugo.toml,../cases/badid.toml
check "unsafe site id prints nothing" 'privatusstats.com' absent

build hugo.toml,../cases/wrongprefix.toml
check "other analytics id prints nothing" 'privatusstats.com' absent

build hugo.toml,../cases/number.toml
check "number as site id prints nothing" 'privatusstats.com' absent

rm -rf public resources themes .hugo_build.lock
exit $fail
