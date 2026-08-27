#!/bin/bash
# bingrss.sh "<query>" [max] — Bing News RSS search
Q="$1"; N="${2:-8}"
UQ=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$Q")
curl -s --max-time 20 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/126 Safari/537.36" \
 "https://www.bing.com/news/search?q=${UQ}&format=rss&mkt=en-US&setlang=en-US&cc=US" \
 | python3 -c "
import sys,re,html
xml=sys.stdin.read()
items=re.findall(r'<item>(.*?)</item>', xml, re.S)
for i in items[:int('$N')]:
    def g(tag):
        m=re.search(r'<'+tag+r'[^>]*>(.*?)</'+tag+r'>', i, re.S)
        return html.unescape(re.sub(r'<[^>]+>','',m.group(1))).strip() if m else ''
    src=re.search(r'<News:Source[^>]*>(.*?)</News:Source>', i, re.S)
    print(f'{g(\"pubDate\")[5:16]} | {src.group(1) if src else \"?\"} | {g(\"title\")}')
    print(f'   {g(\"link\")}')
"
