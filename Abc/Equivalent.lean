import Abc.Radical

/-!
# Equivalent forms of the statement
-/

namespace Abc

/-- The constant form with the hypotheses written as in `abc.variants.lt_constant_mul` of
google-deepmind/formal-conjectures: `c` positive and `{a, b, c}` pairwise coprime. -/
def ABCConjecturePairwise : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ K : ℝ, ∀ a b c : ℕ, 0 < a → 0 < b → 0 < c →
    ({a, b, c} : Set ℕ).Pairwise Nat.Coprime → a + b = c →
    (c : ℝ) < K * (rad (a * b * c) : ℝ) ^ (1 + ε)

/-- The finiteness form: for every `ε > 0`, only finitely many coprime triples with `a + b = c`
satisfy `rad (a * b * c) ^ (1 + ε) < c`. -/
def ABCConjectureFinite : Prop :=
  ∀ ε : ℝ, 0 < ε → {t : ℕ × ℕ × ℕ | 0 < t.1 ∧ 0 < t.2.1 ∧ t.1.Coprime t.2.1 ∧
    t.1 + t.2.1 = t.2.2 ∧ (rad (t.1 * t.2.1 * t.2.2) : ℝ) ^ (1 + ε) < t.2.2}.Finite

theorem pairwise_coprime_iff {a b c : ℕ} (ha : 0 < a) (h : a + b = c) :
    ({a, b, c} : Set ℕ).Pairwise Nat.Coprime ↔ a.Coprime b := by
  subst h
  constructor
  · intro hp
    by_cases hab : a = b
    · subst hab
      have h1 : a.Coprime (a + a) := hp (by simp) (by simp) (by omega)
      have h2 : a = 1 := by simpa using h1
      simp [h2]
    · exact hp (by simp) (by simp) hab
  · intro hc
    have h1 : a.Coprime (a + b) := by simpa using hc
    have h2 : b.Coprime (a + b) := by simpa using hc.symm
    intro x hx y hy hxy
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx hy
    rcases hx with rfl | rfl | rfl <;> rcases hy with rfl | rfl | rfl <;>
      first
        | exact absurd rfl hxy
        | assumption
        | exact Nat.Coprime.symm (by assumption)

theorem abcConjecture_iff_pairwise : ABCConjecture ↔ ABCConjecturePairwise := by
  constructor
  · intro h ε hε
    obtain ⟨K, hK⟩ := h ε hε
    exact ⟨K, fun a b c ha hb _ hp hs => hK a b c ha hb ((pairwise_coprime_iff ha hs).mp hp) hs⟩
  · intro h ε hε
    obtain ⟨K, hK⟩ := h ε hε
    exact ⟨K, fun a b c ha hb hc hs =>
      hK a b c ha hb (by omega) ((pairwise_coprime_iff ha hs).mpr hc) hs⟩

theorem abcConjecture_of_finite (h : ABCConjectureFinite) : ABCConjecture := by
  intro ε hε
  have hfin := h ε hε
  refine ⟨2 + ∑ t ∈ hfin.toFinset, (t.2.2 : ℝ), fun a b c ha hb hc hsum => ?_⟩
  have hr : (1 : ℝ) ≤ (rad (a * b * c) : ℝ) ^ (1 + ε) :=
    Real.one_le_rpow (one_le_rad_cast _) (by linarith)
  have hnn : (0 : ℝ) ≤ ∑ t ∈ hfin.toFinset, (t.2.2 : ℝ) :=
    Finset.sum_nonneg fun _ _ => Nat.cast_nonneg _
  have hmul := mul_le_mul_of_nonneg_left hr hnn
  by_cases hlt : (rad (a * b * c) : ℝ) ^ (1 + ε) < c
  · have hmem : (a, b, c) ∈ hfin.toFinset := by
      rw [Set.Finite.mem_toFinset]
      exact ⟨ha, hb, hc, hsum, hlt⟩
    have hle : (c : ℝ) ≤ ∑ t ∈ hfin.toFinset, (t.2.2 : ℝ) :=
      Finset.single_le_sum (f := fun t : ℕ × ℕ × ℕ => (t.2.2 : ℝ))
        (fun _ _ => Nat.cast_nonneg _) hmem
    linarith
  · rw [not_lt] at hlt
    linarith

theorem finite_of_abcConjecture (h : ABCConjecture) : ABCConjectureFinite := by
  intro ε hε
  obtain ⟨K, hK⟩ := h (ε / 2) (by positivity)
  apply (Set.finite_Iic ((⌈K * (K ^ (2 / ε)) ^ (1 + ε / 2)⌉₊, ⌈K * (K ^ (2 / ε)) ^ (1 + ε / 2)⌉₊,
    ⌈K * (K ^ (2 / ε)) ^ (1 + ε / 2)⌉₊) : ℕ × ℕ × ℕ)).subset
  rintro ⟨a, b, c⟩ ⟨ha, hb, hc, hsum, hlt⟩
  simp only at ha hb hc hsum hlt
  have hr0 : (0 : ℝ) < rad (a * b * c) := by linarith [one_le_rad_cast (a * b * c)]
  have hlt2 := hK a b c ha hb hc hsum
  have h1 : (rad (a * b * c) : ℝ) ^ (1 + ε) =
      (rad (a * b * c) : ℝ) ^ (1 + ε / 2) * (rad (a * b * c) : ℝ) ^ (ε / 2) := by
    rw [← Real.rpow_add hr0]
    ring_nf
  have hpos : (0 : ℝ) < (rad (a * b * c) : ℝ) ^ (1 + ε / 2) := Real.rpow_pos_of_pos hr0 _
  have h2 : (rad (a * b * c) : ℝ) ^ (ε / 2) < K := by
    have h : (rad (a * b * c) : ℝ) ^ (1 + ε / 2) * (rad (a * b * c) : ℝ) ^ (ε / 2) <
        (rad (a * b * c) : ℝ) ^ (1 + ε / 2) * K := by
      rw [← h1, mul_comm _ K]
      exact hlt.trans hlt2
    exact lt_of_mul_lt_mul_left h hpos.le
  have hK0 : 0 < K := lt_of_le_of_lt (Real.rpow_nonneg hr0.le _) h2
  have h3 : (rad (a * b * c) : ℝ) < K ^ (2 / ε) := by
    have h4 : ((rad (a * b * c) : ℝ) ^ (ε / 2)) ^ (2 / ε) < K ^ (2 / ε) :=
      Real.rpow_lt_rpow (Real.rpow_nonneg hr0.le _) h2 (by positivity)
    rwa [← Real.rpow_mul hr0.le, show ε / 2 * (2 / ε) = 1 by field_simp, Real.rpow_one] at h4
  have h5 : (c : ℝ) ≤ K * (K ^ (2 / ε)) ^ (1 + ε / 2) :=
    hlt2.le.trans (mul_le_mul_of_nonneg_left
      (Real.rpow_le_rpow hr0.le h3.le (by positivity)) hK0.le)
  have hcN : c ≤ ⌈K * (K ^ (2 / ε)) ^ (1 + ε / 2)⌉₊ := by
    exact_mod_cast h5.trans (Nat.le_ceil _)
  simp only [Set.mem_Iic, Prod.mk_le_mk]
  omega

theorem abcConjecture_iff_finite : ABCConjecture ↔ ABCConjectureFinite :=
  ⟨finite_of_abcConjecture, abcConjecture_of_finite⟩

end Abc
