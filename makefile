SHELL := /bin/bash
flags := "--pdf-engine=weasyprint"
working_dirs := $(shell ls -d ./*/)

all: docs/index.html

docs/%.pdf: %.md 
	@echo Building $@
	@mkdir -p $(@D)
	pandoc $(flags) $< -o $@ 

pdf_erros.log: $(shell find . -name '*.md') 
	echo $^
	@echo > $@
	@-for file in $?; do \
		case $$(dirname $$file) in \
			page_setup) \
				echo skipping unimportant file $$file;; \
			.) \
				echo skipping unimportant file $$file;; \
			docs) \
				echo skipping unimportant file $$file;; \
			*) \
				TARGET=docs/$$(echo $$file | sed -n "s/md/pdf/p"); \
				echo target $$TARGET; \
				$(MAKE) $$TARGET 2> $@;; \
		esac \
	done
	@if [[ "$$(cat $@)" =~ ^[::space::]*$$ ]]; then \
		echo -e "\033[0;32mAll Good\033[0m"; \
	else \
		echo -e "\033[0;31mPandoc Errors\033[0m"; \
		cat $@; \
		false; \
	fi

page_setup/Home.md: page_setup/Home_foot.md page_setup/Home_head.md pdf_erros.log
	@echo Building $@
	@cp page_setup/Home_head.md $@
	@for FOLDER in $(shell ls -rd ./docs/*/); do \
		echo -e "## $$(basename $$FOLDER):\n" >> $@; \
		for ARTICLE in $$FOLDER/*.pdf ; do \
			NAME=$$(basename $$ARTICLE) ; \
			NAME2=$$NAME; \
			echo "linking on $$NAME." ; \
			echo -e "- [$$NAME2](./$$NAME)\n" >> $@ ; \
		done; \
	done
	@cat page_setup/Home_foot.md >> $@;

docs/index.html: page_setup/Home.md page_setup/Home.css 
	@mkdir -p $(@D)
	pandoc $(flags) $< > $@
	@echo " \
		<head> \
			<title>Fiction | Matthew Bartlett</title> \
			<style> \
				$(shell cat page_setup/Home.css) \
			</style> \
		</head> \
		<body> \
		$$(cat $@) \
		</body>" > $@

.PHONY: clean
clean: 
	-git rm $(shell find docs/ -name "*.pdf")
	-git rm pdf_erros.log
	-git rm page_setup/Home.md 
	-git rm docs/index.html
	-rm -rf docs/ page_setup/Home.md pdf_erros.log
