#!/bin/bash
# gnews.sh "<query>" [days] [max] — Google News RSS search, recent-first
Q="$1"; DAYS="${2:-7}"; N="${3:-10}"
UQ=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]+' when:'+sys.argv[2]))" "$Q" "$DAYS")
curl -s --max-time 20 "https://news.google.com/rss/search?q=${UQ}&hl=en-US&gl=US&ceid=US:en" \
 | python3 -c "
import sys,re,html
xml=sys.stdin.read()
items=re.findall(r'<item>(.*?)</item>', xml, re.S)
for i in items[:int('$N')]:
    def g(tag):
        m=re.search(r'<'+tag+r'[^>]*>(.*?)</'+tag+r'>', i, re.S)
        return html.unescape(re.sub(r'<[^>]+>','',m.group(1))).strip() if m else ''
    src=re.search(r'<source[^>]*>(.*?)</source>', i, re.S)
    print(f'{g(\"pubDate\")[5:16]} | {src.group(1) if src else \"?\"} | {g(\"title\")}')
    print(f'   {g(\"link\")}')
"
