.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

BROWSER := python3.10 -c "$$BROWSER_PYSCRIPT"

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -fr {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .venv
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

lint/licences:
	.venv/bin/pip-licenses --fail-on="GNU Affero General Public License v3" >/dev/null

lint/ruff: warn-no-venv ## check style with ruff
	.venv/bin/ruff --fix .

lint/black: warn-no-venv ## check style with black
	.venv/bin/black .

lint/mypy: warn-no-venv
	mkdir -p .mypy_cache/
	.venv/bin/mypy --install-types --non-interactive tuyau tests

lint/bandit: warn-no-venv
	.venv/bin/bandit  -c .bandit  -r tuyau

lint/safety: warn-no-venv
	.venv/bin/safety check --full-report

lint: warn-no-venv  lint/black lint/ruff lint/mypy lint/bandit lint/safety lint/licences## check style

test: warn-no-venv ## run tests quickly with the default Python
	.venv/bin/pytest -vvv

pre-commit:
	.venv/bin/pre-commit run --all-files

coverage: warn-no-venv ## check code coverage quickly with the default Python
	.venv/bin/coverage run --source . -m pytest -vvv
	.venv/bin/coverage report -m
	.venv/bin/coverage html
	$(BROWSER) htmlcov/index.html

dist: clean ## builds source and wheel package
	pip install setuptools twine wheel
	python3.10 setup.py sdist
	python3.10 setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	python3.10 setup.py install

warn-no-venv:
	@test -d .venv || (echo "🩹🤕  \e[93m Warning: don't forget to execute : \e[39m\e[4mmake dev-install\e[24m \e[39m🩹🤕"; exit 1)

dev-install:
	@python3.10 -m pip install --upgrade pip
	@python3.10 -m pip install virtualenv
	@test -d .venv || python3.10 -m virtualenv .venv
	. .venv/bin/activate ;  .venv/bin/python3.10 -m pip install -r requirements_dev.txt ; .venv/bin/python3.10 -m pip install -r requirements.txt
	.venv/bin/pre-commit install
	.venv/bin/pre-commit autoupdate
	@echo '----'
	@echo "🚧  \e[93m Warning: don't forget to execute : \e[39m\e[4msource .venv/bin/activate\e[24m \e[39m🚧"
	@echo "🧊🚀  \e[92mHave a good day of coding \e[39m 🚀🧊"