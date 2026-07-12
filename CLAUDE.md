This is a repository that tracks the informal math theorems and formal Lean theorems
for proving that a particular algorithmic problem (the Ordering Recovery Problem or ORP)
is NP-hard.

The blueprint folder holds the lean development.

The root folder holds the tex files corresponding to the informal math theorems.

There are 3 tex files:

orp_np_hardness_statements: Just the most important lemmas and theorem statements, without proofs, and with a dependency graph

orp_np_hardness_simplfied: Statements with proofs for the most important lemmas and statements (i.e., those in item 1).

orp_np_hardness_algebra: Appendix with statements and proofs of all auxiliary facts (typically routine algebraic lemmas that are not particularly interesting, but are required).

The three files should be cross linked for easy readability, i.e., lemma and theorem statement numbering across the three files should be consistent.
