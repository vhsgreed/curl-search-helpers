#!/bin/bash
# ddg.sh "<query>" [days: d|w|m] [max] — DuckDuckGo HTML search, results parsed
Q="$1"; DF="${2:-w}"; N="${3:-10}"
UQ=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$Q")
curl -s --max-time 20 -A "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0" \
 "https://html.duckduckgo.com/html/?q=${UQ}&df=${DF}&kl=us-en" \
 | python3 -c "
import sys,re,html
raw=sys.stdin.read()
# result blocks
blocks=re.findall(r'<div class=\"result results_links[^\"]*\".*?</div>\s*</div>', raw, re.S)
if not blocks:
    blocks=re.findall(r'<div class=\"result[^\"]*\".*?</div>', raw, re.S)
count=0
for b in blocks:
    m=re.search(r'class=\"result__a\"[^>]*href=\"([^\"]+)\"[^>]*>(.*?)</a>', b, re.S)
    s=re.search(r'class=\"result__snippet\"[^>]*>(.*?)</a>', b, re.S)
    if not m: continue
    url=m.group(1); title=html.unescape(re.sub(r'<[^>]+>','',m.group(2))).strip()
    snip=html.unescape(re.sub(r'<[^>]+>','',s.group(1))).strip() if s else ''
    print(f'- {title}')
    print(f'  {url}')
    if snip: print(f'  {snip[:220]}')
    count+=1
    if count>=int('$N'): break
if count==0:
    print('(no results parsed)')
"
