import Mathlib

/-!
# The abc conjecture: statement

This file states the abc conjecture of Masser and Oesterlé against Mathlib alone.
-/

namespace Abc

/-- The radical of `n`: the product of the distinct primes dividing `n`. -/
def rad (n : ℕ) : ℕ := ∏ p ∈ n.primeFactors, p

/-- The abc conjecture: for every `ε > 0` there is a constant `K` such that every triple of
positive integers with `a + b = c` and `gcd a b = 1` satisfies `c < K * rad (a * b * c) ^ (1 + ε)`. -/
def ABCConjecture : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ K : ℝ, ∀ a b c : ℕ, 0 < a → 0 < b → a.Coprime b → a + b = c →
    (c : ℝ) < K * (rad (a * b * c) : ℝ) ^ (1 + ε)

end Abc
