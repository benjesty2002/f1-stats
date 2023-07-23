SHELL := /bin/bash

.PHONY: update-csvs
update-csvs:
	source .venv/bin/activate; python3 DataSourceHandler.py


.PHONY: install
install:
	yes '' | brew install sqlite3
	python3 -m venv .venv
	source .venv/bin/activate; \
	pip3 install -r py-requirements.txt

.PHONY: build
build:
	source .venv/bin/activate; python3 build_database.py
