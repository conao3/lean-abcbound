import Abc.Statement

/-!
# Checks that the statement says what is intended
-/

namespace Abc

theorem rad_eq_radical (n : ℕ) : rad n = UniqueFactorizationMonoid.radical n :=
  (Nat.radical_eq_prod_primeFactors).symm

theorem rad_one : rad 1 = 1 := by decide +kernel

theorem rad_twelve : rad 12 = 6 := by decide +kernel

theorem rad_one_mul_eight_mul_nine : rad (1 * 8 * 9) = 6 := by decide +kernel

theorem rad_two_pow (n : ℕ) (hn : n ≠ 0) : rad (2 ^ n) = 2 := by
  simp [rad, Nat.primeFactors_prime_pow hn Nat.prime_two]

/-- Dropping the coprimality hypothesis makes the statement false: the triples
`2 ^ n + 2 ^ n = 2 ^ (n + 1)` all have radical `2`. -/
theorem not_bound_without_coprime :
    ¬ ∀ ε : ℝ, 0 < ε → ∃ K : ℝ, ∀ a b c : ℕ, 0 < a → 0 < b → a + b = c →
      (c : ℝ) < K * (rad (a * b * c) : ℝ) ^ (1 + ε) := by
  intro h
  obtain ⟨K, hK⟩ := h 1 one_pos
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (K * 4) (one_lt_two : (1 : ℝ) < 2)
  have h1 := hK (2 ^ n) (2 ^ n) (2 ^ (n + 1)) (by positivity) (by positivity) (by ring)
  have hrad : rad (2 ^ n * 2 ^ n * 2 ^ (n + 1)) = 2 := by
    rw [← pow_add, ← pow_add]
    exact rad_two_pow _ (by omega)
  rw [hrad] at h1
  have h2 : ((2 : ℕ) : ℝ) ^ ((1 : ℝ) + 1) = 4 := by norm_num
  rw [h2] at h1
  have h3 : (2 : ℝ) ^ n ≤ 2 ^ (n + 1) := pow_le_pow_right₀ one_le_two (Nat.le_succ n)
  push_cast at h1
  linarith

end Abc
