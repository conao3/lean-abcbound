# lean-abcbound

The abc conjecture of Masser and Oesterlé, stated in Lean 4 against Mathlib, with checks that the statement says what is intended.

## Status

`Abc.ABCConjecture` is a `Prop`. A proof of it is the open goal of this repository. The acceptance condition is a theorem `Abc.abc : Abc.ABCConjecture` whose `#print axioms` output lists `propext`, `Classical.choice`, and `Quot.sound` only.

## The statement

`Abc/Statement.lean` imports Mathlib alone.

```lean
def rad (n : ℕ) : ℕ := ∏ p ∈ n.primeFactors, p

def ABCConjecture : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ K : ℝ, ∀ a b c : ℕ, 0 < a → 0 < b → a.Coprime b → a + b = c →
    (c : ℝ) < K * (rad (a * b * c) : ℝ) ^ (1 + ε)
```

This is the constant form of the conjecture, the same shape as `abc.variants.lt_constant_mul` in [google-deepmind/formal-conjectures](https://github.com/google-deepmind/formal-conjectures/blob/main/FormalConjectures/Wikipedia/ABC.lean).

## Checked results

- `Abc/Sanity.lean`: `rad` equals Mathlib's `UniqueFactorizationMonoid.radical` on `ℕ`, values of `rad` on concrete inputs, and `not_bound_without_coprime` (the bound fails once the coprimality hypothesis is removed, witnessed by `2 ^ n + 2 ^ n = 2 ^ (n + 1)`).
- `Abc/Radical.lean`: `rad_pos`, `rad_dvd`, `rad_le`, `rad_mul` for coprime factors, and `rad_mul_mul_add`.
- `Abc/Equivalent.lean`: `abcConjecture_iff_pairwise` (the statement with `c` positive and `{a, b, c}` pairwise coprime) and `abcConjecture_iff_finite` (for every `ε > 0`, finitely many coprime triples satisfy `rad (a * b * c) ^ (1 + ε) < c`).

`audit.expected` records the axioms each of these theorems depends on.

## Where to continue

[docs/roadmap.md](docs/roadmap.md) lists the next steps inside this repository and the starting point of each stage of the route through inter-universal Teichmüller theory.

## Commands

```console
$ nix develop --command make check
```

`make check` formats the flake, downloads the prebuilt Mathlib, builds the library, and compares the axiom audit with `audit.expected`. `make audit` regenerates `audit.expected`.

## License

Apache-2.0
