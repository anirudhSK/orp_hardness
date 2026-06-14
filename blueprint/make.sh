#!/usr/bin/env bash
# Build the web (HTML) version of the blueprint.
#
# This is a *standalone* leanblueprint project: there is no Lean/Lake project, so
# the usual `leanblueprint web` CLI (which requires a lakefile) does not apply.
# We invoke plastex directly with the same plugins leanblueprint would use.
#
# Prerequisites (one-time):
#   - graphviz with C headers:   brew install graphviz
#   - a Python venv with leanblueprint (pulls plastex + plugins), built against
#     the graphviz headers:
#       python3 -m venv .blueprint-venv
#       . .blueprint-venv/bin/activate
#       CFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" \
#         pip install pygraphviz
#       pip install leanblueprint
#
# Output: blueprint/web/index.html  (open it, or run:  ./make.sh serve )

set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
VENV="$REPO/.blueprint-venv"

if [ ! -d "$VENV" ]; then
  echo "error: $VENV not found. See the prerequisites comment in this script." >&2
  exit 1
fi

# shellcheck disable=SC1091
. "$VENV/bin/activate"
export PATH="/opt/homebrew/bin:$PATH"   # for graphviz's `dot`

cd "$HERE/src"
rm -rf ../web
plastex --config=plastex.cfg web.tex

# Repoint the per-node "Lean" links at GitHub source (no doc-gen4 site needed).
python "$HERE/tools/link_to_source.py"

echo
echo "Built blueprint -> $HERE/web/index.html"

if [ "${1:-}" = "serve" ]; then
  cd ../web
  echo "Serving at http://localhost:8000/  (Ctrl-C to stop)"
  python -m http.server 8000
fi
