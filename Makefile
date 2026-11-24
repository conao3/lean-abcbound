.PHONY: check
check:
	nix fmt -- --ci
	lake exe cache get
	lake build
	lake env lean Audit.lean | diff -u audit.expected -

.PHONY: fmt
fmt:
	nix fmt

.PHONY: audit
audit:
	lake build
	lake env lean Audit.lean > audit.expected
