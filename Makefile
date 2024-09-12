.PHONY: diagrams
diagrams:
	find diagrams -iname '*.d2' -print0 | xargs -0 -I {} d2 "{}"

pre-commit-init:
	pre-commit install
	pre-commit install --hook-type commit-msg

pre-commit-update:
	pre-commit autoupdate
