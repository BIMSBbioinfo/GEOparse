.PHONY: clean-pyc clean-build docs clean clean-venv

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean-test - remove test and coverage artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "docs - generate Sphinx HTML documentation, including API docs"
	@echo "release - package and upload a release"
	@echo "release-test - package and upload a test release"
	@echo "dist - package"
	@echo "install - install the package to the active Python's site-packages"

clean: clean-venv clean-build clean-pyc clean-test

clean-venv:
	rm -fr .venv

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

lint:
	flake8 GEOparse tests

test:
	python setup.py test

test-all:
	tox

coverage:
	coverage run --source GEOparse setup.py test
	coverage report -m
	coverage html
	# open htmlcov/index.html

docs:
	rm -f docs/GEOparse.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ GEOparse
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	# open docs/_build/html/index.html

release: clean
	python setup.py register -r pypi
	python setup.py sdist upload -r pypi
	python setup.py bdist_wheel upload -r pypi

release-test: clean
	python setup.py register -r pypitest
	python setup.py sdist upload -r pypitest
	python setup.py bdist_wheel upload -r pypitest

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

.venv:
	python3 -m venv .venv

venv-install: clean-venv .venv
	. .venv/bin/activate && \
		python setup.py install

install: clean
	python setup.py install
