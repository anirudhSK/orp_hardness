# Blueprint — NP-Hardness of the Ordering Recovery Problem

A [leanblueprint](https://github.com/PatrickMassot/leanblueprint)-style blueprint
for the Lean 4 + Mathlib formalization in
[`lea-frontier:LeaFrontier/OrderingRecovery`](https://github.com/chinmayhegde/lea-frontier/tree/orp-np-hardness/LeaFrontier/OrderingRecovery)
(branch `orp-np-hardness`). Each node pairs an informal mathematical statement
and proof with the Lean declaration that formalizes it (`\lean{...}`), and the
dependency graph is built from the `\uses{...}` edges.

It is **standalone**: there is no Lean/Lake project here, so the blueprint is
authored in LaTeX and rendered to HTML by plastex (no Lean/Mathlib build
required). Proof status (`\leanok`) is recorded from the formalization, which is
reported `sorry`-free modulo three explicit axioms (`fast_np_complete`,
`reduction_yields_np_hard`, `sum_perm_comp_embedding`).

## Layout

```
blueprint/
  src/
    web.tex          # web (HTML) document wrapper
    print.tex        # pdf document wrapper
    content.tex      # all 33 nodes: statements + proofs + \lean/\uses/\leanok
    plastex.cfg      # plastex config (plugins, output dir, split level)
    macros/          # common / web / print LaTeX macros
    blueprint.sty, extra_styles.css
  web/               # generated HTML site (gitignored)
  make.sh            # build script
  README.md
```

## Build

One-time setup (macOS / Homebrew):

```bash
brew install graphviz
python3 -m venv .blueprint-venv
. .blueprint-venv/bin/activate
CFLAGS="-I/opt/homebrew/include" LDFLAGS="-L/opt/homebrew/lib" pip install pygraphviz
pip install leanblueprint
```

Then, from the repo root:

```bash
./blueprint/make.sh          # builds blueprint/web/index.html
./blueprint/make.sh serve    # builds, then serves at http://localhost:8000/
```

(The standard `leanblueprint web` CLI is **not** used here because it requires a
`lakefile`; `make.sh` calls plastex directly with the same plugins.)

## Lean source links

Each node's **"Lean" link** jumps to the exact declaration line in the
lea-frontier source on GitHub (e.g.
`.../blob/<sha>/LeaFrontier/OrderingRecovery/ReductionCorrect.lean#L164`). This
needs no doc-gen4 site and no Lean build.

leanblueprint normally builds these links as `<dochome>/find/#doc/<decl>`, which
only resolves against a published doc-gen4 API-docs site. Instead, `make.sh` runs
`tools/link_to_source.py` after plastex, which rewrites every such link using
the pinned map in **`decl_links.json`** (fully-qualified declaration name →
GitHub blob URL at a fixed commit SHA, so links don't rot).

To refresh the map (e.g. after the formalization changes), regenerate
`decl_links.json` against a fresh checkout of the lea-frontier
`orp-np-hardness` branch, then rebuild. If you would rather have rendered API
docs with hover types, publish doc-gen4 docs for `LeaFrontier.OrderingRecovery`,
point `\dochome{...}` (in `src/web.tex`) at them, and remove the
`link_to_source.py` step.

## Note on `\leanok`

`\leanok` markers are transcribed from the formalization report, not verified
here. To verify the `\lean{...}` names exist and are `sorry`-free against the
actual Lean source, run `leanblueprint checkdecls` from inside the lea-frontier
Lake project (requires building it).
