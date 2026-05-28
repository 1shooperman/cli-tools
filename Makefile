.PHONY: test lint sast

test:
	bats tests/

lint:
	shellcheck bin/* lib/*.sh