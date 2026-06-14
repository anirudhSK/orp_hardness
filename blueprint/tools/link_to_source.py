#!/usr/bin/env python3
"""Rewrite the blueprint's per-node "Lean" links to point at GitHub source.

leanblueprint builds each Lean link as `<dochome>/find/#doc/<decl>`, a pattern
that only resolves against a published doc-gen4 site. This standalone blueprint
has no such site, so instead we repoint every link at the exact declaration line
in the lea-frontier source on GitHub, using the pinned map in
`blueprint/decl_links.json` (keyed by fully-qualified declaration name).

Run after plastex (see make.sh). Idempotent.
"""
from __future__ import annotations
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent.parent          # blueprint/
WEB = HERE / "web"
MAP_PATH = HERE / "decl_links.json"

# Matches an href whose fragment is `#doc/<decl>` (the doc-gen4 find pattern),
# capturing the declaration name.
HREF_RE = re.compile(r'href="[^"]*#doc/([^"]+)"')


def main() -> int:
    if not WEB.is_dir():
        print(f"error: {WEB} not found (build the site first)", file=sys.stderr)
        return 1
    decl_map = json.loads(MAP_PATH.read_text())

    rewritten = 0
    missing: set[str] = set()
    for html in WEB.glob("*.html"):
        text = html.read_text(encoding="utf-8")

        def repl(m: re.Match) -> str:
            nonlocal rewritten
            decl = m.group(1)
            url = decl_map.get(decl)
            if url is None:
                missing.add(decl)
                return m.group(0)
            rewritten += 1
            return f'href="{url}"'

        new = HREF_RE.sub(repl, text)
        if new != text:
            html.write_text(new, encoding="utf-8")

    print(f"link_to_source: rewrote {rewritten} Lean link(s) to GitHub source")
    if missing:
        print(f"  WARNING: no source mapping for: {sorted(missing)}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
