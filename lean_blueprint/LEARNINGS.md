# Lean Blueprint Setup Learnings

Lessons learned setting up leanblueprint from scratch on Ubuntu with Lean 4.29 / Mathlib v4.29.0.

---

## 1. lean_blueprint must be its own git repository

`leanblueprint` uses GitPython with `search_parent_directories=True` to locate the
project root. If `lean_blueprint/` lives inside a parent git repo (e.g. a paper repo),
it climbs up to the parent root and then fails to find `lakefile.toml` there.

**Fix:** run `git init` inside `lean_blueprint/` to make it its own git repository.
Always run `leanblueprint` commands from inside that directory.

---

## 2. Mathlib can't be pinned by version on Reservoir

Mathlib publishes all releases as version `0.0.0` on the Lean Reservoir registry, so
`version = "=4.29.0"` fails.

**Fix:** Use a direct git source with the `rev` field (Lake 5 syntax):

```toml
[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4"
rev = "v4.29.0"
```

---

## 3. Lake 5 dependency syntax changed

Lake 5 (shipped with Lean 4.29+) uses `git` and `rev` for git dependencies, not the
old `from` and `revision` keys. Using the old keys produces:

```
error: mathlib: ill-formed dependency: dependency is missing a source
```

---

## 4. Toolchain version must match Mathlib

The `lean-toolchain` file and the Mathlib git tag must agree. Check:

```bash
curl -s https://raw.githubusercontent.com/leanprover-community/mathlib4/v4.29.0/lean-toolchain
# → leanprover/lean4:v4.29.0
```

Set `lean-toolchain` to the same string.

---

## 5. plastex.cfg is required for the blueprint Python plugin to load

Without a `plastex.cfg` in `blueprint/src/`, plastex falls back to the LaTeX
implementation of `blueprint.sty` and `\lean`, `\leanok`, `\uses` are unrecognised.

**Fix:** create `blueprint/src/plastex.cfg`:

```ini
[general]
renderer=HTML5
copy-theme-extras=yes
plugins=plastexdepgraph plastexshowmore leanblueprint

[document]
toc-depth=2
toc-non-files=True

[files]
directory=../web/
split-level=1

[html5]
localtoc-level=2
extra-css=extra_styles.css
mathjax-dollars=False
```

---

## 6. blueprint.sty must be copied into blueprint/src/

plasTeX looks for `blueprint.sty` relative to the source directory. Copy it from the
leanblueprint Python package:

```bash
cp $(python3 -c "import leanblueprint; print(leanblueprint.__file__.replace('__init__.py',''))") \
   templates/blueprint.sty blueprint/src/
```

Or simply:
```bash
cp ~/.local/lib/python3.10/site-packages/leanblueprint/templates/blueprint.sty blueprint/src/
```

---

## 7. plastexdepgraph requires both libgraphviz-dev AND graphviz

`pip install plastexdepgraph` builds `pygraphviz`, which needs the C headers:

```bash
sudo apt-get install -y libgraphviz-dev
```

But generating the dependency graph also requires the `tred` binary at runtime:

```bash
sudo apt-get install -y graphviz
```

Both packages are needed.

---

## 8. extra_styles.css must exist (can be empty)

`plastex.cfg` references `extra-css=extra_styles.css`. If the file is missing, plastex
logs an error. Create an empty file:

```bash
touch blueprint/src/extra_styles.css
```

---

## 9. The dependency graph is on its own page

The graph is not embedded in `index.html`. It lives at `dep_graph_document.html` and
is linked from the sidebar nav under "Dependency graph".

---

## 10. dep_graph_document.html requires an HTTP server to render

The page uses `d3-graphviz` with a Web Worker. Browsers block Web Workers on `file://`
URLs, so the graph div stays blank.

**Fix:** serve over HTTP:

```bash
cd blueprint/web && python3 -m http.server 8080
# then open http://localhost:8080/dep_graph_document.html
```

---

## 11. \lean{} links for local declarations will 404 until you host docs

`\lean{MyProject.myTheorem}` generates a link to `dochome/find/#doc/MyProject.myTheorem`.
If you haven't published your project's doc-gen output, the link 404s.

**Fix:** remove `\lean{}` annotations for local declarations until docs are hosted.
The `\lean{Even}` annotation (a Mathlib declaration) works because `dochome` defaults
to `https://leanprover-community.github.io/mathlib4_docs`.

---

## 12. macros/ needs three files

leanblueprint expects `macros/common.tex`, `macros/web.tex`, and `macros/print.tex`.
`print.tex` must define dummy no-op versions of the web-only commands:

```latex
\newcommand{\lean}[1]{}
\newcommand{\leanok}{}
\newcommand{\notready}{}
\newcommand{\uses}[1]{}
\newcommand{\proves}[1]{}
```
