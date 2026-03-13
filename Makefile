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
	tox -p -e safety -e bandit
	gitleaks detect --report-format json --report-path leak_report

# generate abci docstrings
# check copyright
# generate latest hashes for updated packages
# generate docs for updated packages
# fix hashes in docs
.PHONY: generators
generators: clean-cache
	tox -e abci-docstrings
	tox -e fix-copyright
	tox -e lock-packages
	tox -e generate-api-documentation
	tox -e fix-doc-hashes

.PHONY: common-checks-1
common-checks-1:
	tox -p -e check-copyright -e check-hash -e check-packages

.PHONY: common-checks-2
common-checks-2:
	tox -e check-api-docs
	tox -e check-abci-docstrings
	tox -e check-abciapp-specs
	tox -e check-handlers
	tox -e check-dialogues
	tox -e check-doc-links-hashes

.PHONY: all-checks
all-checks: clean security generators common-checks-1 common-checks-2

v := $(shell pip -V | grep virtualenvs)

.PHONY: new_env
new_env: clean
	if [ ! -z "$(which svn)" ];\
	then\
		echo "The development setup requires SVN, exit";\
		exit 1;\
	fi;\

	if [ -z "$v" ];\
	then\
		pipenv --rm;\
		pipenv --clear;\
		pipenv --python 3.14;\
		pipenv install --dev;\
		echo "Enter virtual environment with all development dependencies now: 'pipenv shell'.";\
	else\
		echo "In a virtual environment! Exit first: 'exit'.";\
	fi
