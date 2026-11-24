# AGENTS.md

`lean-abcbound` states the abc conjecture in Lean 4 against Mathlib and collects checked results about the statement.

## Layout

- `Abc/Statement.lean`: `Abc.rad` and `Abc.ABCConjecture`. It imports Mathlib alone.
- `Abc/Sanity.lean`: theorems that pin down the meaning of the statement.
- `Audit.lean`: `#print axioms` for every theorem in the library. `audit.expected` holds its output.
- `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`: the Lean and Mathlib versions.

## Conventions

- Every theorem depends on `propext`, `Classical.choice`, and `Quot.sound` only. `sorry`, `admit`, `native_decide`, and `axiom` declarations stay out of the library.
- Each new theorem gets a `#print axioms` line in `Audit.lean`, and `make audit` regenerates `audit.expected` in the same commit.
- The README describes a result as proved only when the theorem is in the library and in `audit.expected`.
- The toolchain comes from elan in the devShell, and Mathlib comes from `lake exe cache get`.
- Commit messages, comments, and documentation are in English.

## Verification

```console
$ nix develop --command make check
```
