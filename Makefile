OPEN_AEA_REPO_PATH := "${OPEN_AEA_REPO_PATH}"
DEPLOYMENT_TYPE := "${DEPLOYMENT_TYPE}"
SERVICE_ID := "${SERVICE_ID}"
PLATFORM_STR := $(shell uname)

.PHONY: clean
clean: clean-test clean-pyc

.PHONY: clean-pyc
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '.DS_Store' -exec rm -fr {} +

.PHONY: clean-test
clean-test: clean-cache
	rm -fr .tox/
	rm -f .coverage
	find . -name ".coverage*" -not -name ".coveragerc" -exec rm -fr "{}" \;
	rm -fr coverage.xml
	rm -fr htmlcov/
	find . -name 'log.txt' -exec rm -fr {} +
	find . -name 'log.*.txt' -exec rm -fr {} +

# removes various cache files
.PHONY: clean-cache
clean-cache:
	find . -type d -name .hypothesis -prune -exec rm -rf {} \;
	rm -fr .pytest_cache
	rm -fr .mypy_cache/

# safety: checks dependencies for known security vulnerabilities
# bandit: security linter
.PHONY: security
security:
	tomte tox -p -e safety -e bandit
	tomte tox -e gitleaks

# generate abci docstrings
# format copyright headers in source
# regenerate package hashes
.PHONY: generators
generators: clean-cache
	tomte tox -e abci-docstrings
	tomte format-copyright --author valory
	uv run autonomy packages lock

.PHONY: common-checks-1
common-checks-1:
	tomte check-copyright --author valory
	tomte tox -p -e check-hash -e check-packages

.PHONY: common-checks-2
common-checks-2:
	tomte tox -e check-abci-docstrings
	tomte tox -e check-abciapp-specs
	tomte tox -e check-handlers

.PHONY: all-checks
all-checks: clean security generators common-checks-1 common-checks-2

.PHONY: new_env
new_env: clean
	if [ -z "$$VIRTUAL_ENV" ];\
	then\
		rm -rf .venv;\
		uv venv --python 3.14 .venv;\
		uv sync --all-groups;\
		echo "Enter virtual environment with all development dependencies now: 'source .venv/bin/activate'.";\
	else\
		echo "In a virtual environment! Exit first: 'deactivate'.";\
	fi
