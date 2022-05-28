SHELL := /bin/bash

.PHONY: update-csvs
update-csvs:
	source .venv/bin/activate; \
	kaggle datasets download --unzip --force \
		-d rohanrao/formula-1-world-championship-1950-2020 \
		-p ./csvs


.PHONY: install
install:
	cat unix-requirements.txt | xargs brew install
	python3 -m venv .venv
	source .venv/bin/activate; \
	pip3 install -r py-requirements.txt

.PHONY: build
build:
	source .venv/bin/activate; python3 build_database.py
