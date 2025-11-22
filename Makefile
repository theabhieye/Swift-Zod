.PHONY: lint lint-fix test install-hooks

ci:
	swiftlint lint --strict
	swift test

lint:
	./scripts/lint.sh

lint-fix:
	swiftlint --fix

test:
	swift test

install-hooks:
	cp .githooks/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	echo "Git hooks installed."
