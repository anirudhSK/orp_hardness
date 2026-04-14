# Lean Blueprint — Setup Notes

## Next steps to get it running

1. Install leanblueprint: `pip install leanblueprint`
2. Fetch Mathlib cache: `lake exe cache get` (run from this directory)
3. Build the blueprint website: `leanblueprint web` (run from this directory)
4. Update `lean-toolchain` and the Mathlib `revision` in `lakefile.toml` to match
   whatever toolchain Mathlib currently ships — check
   https://github.com/leanprover-community/mathlib4/releases for the exact tag.
