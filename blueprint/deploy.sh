#!/usr/bin/env bash
# Build the blueprint and publish it to the `gh-pages` branch, which GitHub Pages
# serves at https://anirudhsk.github.io/orp_hardness/ .
#
# This replaces the entire contents of gh-pages with the freshly built site.
# Run from anywhere:  ./blueprint/deploy.sh

set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"   # blueprint/
REPO="$(cd "$HERE/.." && pwd)"

# 1. Build the static site into blueprint/web/
"$HERE/make.sh"

# 2. Check out gh-pages in a throwaway worktree and replace its contents.
cd "$REPO"
git fetch origin gh-pages
WT="$(mktemp -d)"
git worktree add --force "$WT" -B gh-pages origin/gh-pages >/dev/null

# wipe tracked files (keep the .git pointer), then copy the new site in
find "$WT" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
cp -R "$HERE/web/." "$WT/"
touch "$WT/.nojekyll"   # tell Pages not to run Jekyll (preserves js/ etc.)

cd "$WT"
git add -A
if git diff --cached --quiet; then
  echo "deploy: no changes"
else
  git commit -q -m "deploy blueprint $(date -u +%FT%TZ)"
  git push origin gh-pages
fi

cd "$REPO"
git worktree remove --force "$WT"
echo "Deployed -> https://anirudhsk.github.io/orp_hardness/"
