#!/usr/bin/env python3
import html, os, re, sys
BOOK = os.path.join(os.path.dirname(__file__), 'lfs')

def extract(path):
    t = open(path, encoding='utf-8', errors='replace').read()
    blocks = re.findall(r'<pre[^>]*class="userinput"[^>]*>(.*?)</pre>', t, re.S)
    return [html.unescape(re.sub(r'<[^>]+>', '', b)).strip() for b in blocks]

for pg in sys.argv[1:]:
    p = os.path.join(BOOK, pg)
    print('############', pg)
    if not os.path.exists(p):
        print('  <MISSING PAGE>')
        continue
    for b in extract(p):
        print(b)
        print('-----')
