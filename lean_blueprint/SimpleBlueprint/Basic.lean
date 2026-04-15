import Mathlib.Algebra.Group.Nat.Even

/-!
# Basic parity results

This file contains the Lean proofs corresponding to the blueprint
in `blueprint/src/content.tex`.
-/

/-- The sum of two even natural numbers is even. -/
theorem sum_of_evens (a b : ℕ) (ha : Even a) (hb : Even b) : Even (a + b) := by
  obtain ⟨j, rfl⟩ := ha
  obtain ⟨k, rfl⟩ := hb
  exact ⟨j + k, by omega⟩
