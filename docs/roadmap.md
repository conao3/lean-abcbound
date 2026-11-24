# Roadmap

The goal is a theorem `Abc.abc : Abc.ABCConjecture` whose `#print axioms` output lists `propext`, `Classical.choice`, and `Quot.sound` only. This page records what the library holds and where each remaining piece of work starts.

## What the library holds

| File | Content |
|---|---|
| `Abc/Statement.lean` | `rad` and `ABCConjecture` (constant form), over Mathlib alone |
| `Abc/Sanity.lean` | values of `rad`, agreement with Mathlib's `radical`, failure of the bound once coprimality is removed |
| `Abc/Radical.lean` | `rad_pos`, `rad_dvd`, `rad_le`, `rad_mul` for coprime factors, `rad_mul_mul_add` |
| `Abc/Equivalent.lean` | `abcConjecture_iff_pairwise` (the hypotheses of formal-conjectures) and `abcConjecture_iff_finite` (the finiteness form) |

A proof of any one of `ABCConjecture`, `ABCConjecturePairwise`, `ABCConjectureFinite` closes the goal through these equivalences.

## Small steps inside this repository

Each step is a self-contained theorem over Mathlib and is checked by `make check`.

1. The quality form: finitely many coprime triples with `log c / log (rad (a * b * c)) > 1 + ε`, as in `abc.variants.quality` of [formal-conjectures](https://github.com/google-deepmind/formal-conjectures/blob/main/FormalConjectures/Wikipedia/ABC.lean). It follows from `ABCConjectureFinite` by taking logarithms; the triple `(1, 1, 2)` has `rad = 2 > 1`, so the logarithm in the denominator is positive for every triple.
2. The exponent `1 + ε` is needed: the bound `c < K * rad (a * b * c)` fails for every `K`, witnessed by `1 + (3 ^ (2 ^ n) - 1) = 3 ^ (2 ^ n)`, where `2 ^ (n + 2)` divides `3 ^ (2 ^ n) - 1`.
3. Consequences of `ABCConjecture`: Fermat's equation `x ^ n + y ^ n = z ^ n` has no coprime positive solutions for all large `n`. Mathlib states the equation in `Mathlib/NumberTheory/FLT/Basic.lean`.
4. The Szpiro conjecture for elliptic curves over `ℚ`, as a statement. Mathlib has minimal Weierstrass equations (`Mathlib/AlgebraicGeometry/EllipticCurve/Reduction.lean`) and heights (`Mathlib/NumberTheory/Height/`); the conductor is the definition to add first.

## The route through inter-universal Teichmüller theory

Mochizuki's progress report ([On the formalization of IUT, April 2026](https://www.kurims.kyoto-u.ac.jp/~motizuki/Formalization%20of%20IUT%20(2026-04).pdf), §2) divides the formalization into five stages. The stage numbers below are his.

| Stage | Content | State in the sources | Where to start |
|---|---|---|---|
| 1 | [IUTchIII] Theorem 3.11 ⟹ Corollary 3.12 | Disputed since the 2018 report of Scholze and Stix. Mochizuki's group has skeletal Lean code for the last portion, "3.11.5 ⟹ 3.12". Project LANA reports that a proof of the required compatibility is still to be reconstructed. | [LANA interim report, July 2026](https://ncatlab.org/nlab/files/LANAProject-Report-July2026.pdf), §8 "On the logic from theorem 3.11 to corollary 3.12" and §9 "Points to be clarified": the open point is whether a certain diagram commutes, or a certain isomorphism is the identity, once the indeterminacies Ind1, Ind2, Ind3 are taken into account |
| 2 | Proof of Theorem 3.11 modulo [IUTchI–II] | Skeletal Lean code in progress at RIMS | Mochizuki's report, §3 and §4 |
| 3 | [IUTchI–II] modulo earlier results | To be formalized | The papers [IUTchI], [IUTchII] |
| 4 | Earlier results (1995–2015): anabelian geometry, Frobenioids, the étale theta function | Mochizuki's report describes these as understood by a larger class of mathematicians and as candidates for autoformalization. An anabelian geometry library is the first objective of Project LANA. | The reference list of Mochizuki's report: [pGC], [AbsAnb], [SemiAn], [FrdI–II], [EtTh], [GenEll], [AbsTopI–III] |
| 5 | Numerical aspects: [IUTchIV], [ExpEst] | To be formalized; described in the same terms as stage 4 | The papers [IUTchIV] and [ExpEst] |

The Lean code named in the two reports is described there in prose. Its public location is the first thing to look up before working on stages 1 and 2.

Stage 1 decides whether this route proves the conjecture. Stages 4 and 5 are the parts that can be worked on independently of that question, and stage 4 is also the part with no counterpart in Mathlib.

## The route through a new proof

The Lean proof of the Riemann Hypothesis released on 20 November 2026 is the model for how a result of this size is accepted: a statement file over Mathlib alone, a comparison of the proved theorem against that statement, and several independent kernels on an exported proof ([joint statement of the Lean FRO and the Mathlib Initiative](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/), [verification files](https://math.mit.edu/~drew/grh/)). `Abc/Statement.lean` plays the role of the statement file here.

## Related results in Mathlib

- `UniqueFactorizationMonoid.radical` (`Mathlib/RingTheory/Radical/`), equal to `Abc.rad` on `ℕ` by `Abc.rad_eq_radical`.
- `Polynomial.abc`, the Mason–Stothers theorem (`Mathlib/NumberTheory/FLT/MasonStothers.lean`): the analogue of the conjecture for polynomials.
- Heights (`Mathlib/NumberTheory/Height/`) and elliptic curves (`Mathlib/AlgebraicGeometry/EllipticCurve/`).

The paths refer to Mathlib `v4.35.0`.
