import Abc.Statement

/-!
# Basic facts about `rad`
-/

namespace Abc

theorem rad_pos (n : ℕ) : 0 < rad n :=
  Finset.prod_pos fun _ hp => (Nat.prime_of_mem_primeFactors hp).pos

theorem rad_dvd (n : ℕ) : rad n ∣ n :=
  Nat.prod_primeFactors_dvd n

theorem rad_le {n : ℕ} (hn : n ≠ 0) : rad n ≤ n :=
  Nat.le_of_dvd (Nat.pos_of_ne_zero hn) (rad_dvd n)

theorem rad_mul {a b : ℕ} (h : a.Coprime b) : rad (a * b) = rad a * rad b := by
  rw [rad, rad, rad, h.primeFactors_mul, Finset.prod_union h.disjoint_primeFactors]

theorem one_le_rad_cast (n : ℕ) : (1 : ℝ) ≤ (rad n : ℝ) := by
  exact_mod_cast rad_pos n

/-- For a coprime pair, the radical of `a * b * (a + b)` splits into three factors. -/
theorem rad_mul_mul_add {a b : ℕ} (h : a.Coprime b) :
    rad (a * b * (a + b)) = rad a * rad b * rad (a + b) := by
  have ha : a.Coprime (a + b) := by simpa using h
  have hb : b.Coprime (a + b) := by simpa using h.symm
  have hc : (a * b).Coprime (a + b) := Nat.Coprime.mul_left ha hb
  rw [rad_mul hc, rad_mul h]

end Abc
