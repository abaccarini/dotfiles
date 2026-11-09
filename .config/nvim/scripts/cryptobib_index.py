#!/usr/bin/env python3
"""Index CryptoBib's crypto.bib for the Neovim citation picker (lua/cryptobib.lua).

Usage: cryptobib_index.py CRYPTO_BIB OUT_TSV

Writes one line per entry, newest year first:

    key <TAB> year <TAB> authors' last names <TAB> title <TAB> start <TAB> length

start is the 1-based byte offset of the entry's '@' and length its size in bytes, so the picker
copies an entry verbatim with `tail -c +start | head -c length`.  CryptoBib is generated, so its
layout is fixed: every entry starts with "@Type{KEY," at the start of a line and ends with a line
holding only "}", and every field starts on its own line as "  name = ".
"""
import os
import re
import sys

START = re.compile(r'^@(\w+)\{([^,\s]+),', re.M)
FIELD = re.compile(r'^  ([A-Za-z]+) *= *', re.M)
TEX = re.compile(r'\\[A-Za-z]+ *|\\.')


def clean(value):
    """A field value as one line of plain text: quotes, braces and TeX commands dropped."""
    value = value.strip().rstrip(',').strip()
    if len(value) >= 2 and value[0] == value[-1] == '"':
        value = value[1:-1]
    value = TEX.sub('', value).replace('{', '').replace('}', '')
    # The file is read as Latin-1 so that string offsets are byte offsets; the text is UTF-8.
    value = value.encode('latin-1').decode('utf-8', 'replace')
    return ' '.join(value.split())


def last_names(authors):
    names = [n.strip() for n in re.split(r'\s+and\s+', authors) if n.strip()]
    return ', '.join(n.split(',')[0].strip() if ',' in n else n.split()[-1] for n in names)


def main(src, dst):
    with open(src, 'rb') as f:
        text = f.read().decode('latin-1')
    rows = []
    for m in START.finditer(text):
        end = text.find('\n}\n', m.end())
        end = len(text) if end < 0 else end + 2  # just past the closing brace
        body = text[m.end():end]
        fields = list(FIELD.finditer(body))
        found = {}
        for i, f in enumerate(fields):
            name = f.group(1).lower()
            if name in ('author', 'title', 'year') and name not in found:
                stop = fields[i + 1].start() if i + 1 < len(fields) else len(body) - 1
                found[name] = clean(body[f.end():stop])
        rows.append((found.get('year', ''), m.group(2), last_names(found.get('author', '')),
                     found.get('title', ''), m.start() + 1, end - m.start()))
    rows.sort(key=lambda row: row[0], reverse=True)  # newest first, file order within a year
    tmp = dst + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as out:
        for year, key, authors, title, start, length in rows:
            shown = (key, year, authors, title)
            out.write('\t'.join(s.replace('\t', ' ') for s in shown) + f'\t{start}\t{length}\n')
    os.replace(tmp, dst)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
