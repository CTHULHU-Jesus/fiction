
ifeq ($(start_dir),)
	start_dir := $(shell pwd)
endif
s_dir := $(shell realpath $(start_dir)/../stories)
d_dir := $(shell realpath $(start_dir)/../docs)
m_dir := $(shell realpath $(start_dir)/../page_setup)
flags := "--pdf-engine=weasyprint"

all:


$(d_dir)/%.pdf: $(s_dir)/%.md $(d_dir)
	pandoc $(flags) $< -o $@ 

$(d_dir)/Home.md: $(m_dir)/Home_foot.md $(m_dir)/Home_head.md $(d_dir)
	cp $(m_dir)/Home_head.md $(d_dir)/Home.md
	@for ARTICLE in $(s_dir)/*.md ; do \
		NAME=$$(basename $$ARTICLE .md) ; \
		NAME2=$$NAME; \
		echo "linking on $$NAME." ; \
		echo "- [$$NAME2](./$$NAME.pdf)\n" >> $(d_dir)/Home.md ; \
	done
	cat $(m_dir)/Home_foot.md >> $(d_dir)/Home.md;

$(d_dir)/index.html: $(d_dir)/Home.md $(m_dir)/Home.css $(d_dir)
	pandoc $(flags) $(d_dir)/Home.md -o $(d_dir)/index.html;
	@echo "\n\
		<head>\n\
			<title>Fiction | Matthew Bartlett</title>\n\
			<style>\n\
				$$(cat $(m_dir)/Home.css)\n\
			</style>\n\
		</head>\n\
		<body>\n\
		$$(cat $(d_dir)/index.html)\n\
		</body>" > $(d_dir)/index.html;
	rm $(d_dir)/Home.md

$(d_dir):
	mkdir -p $(d_dir)

.PHONY: install
install: $(d_dir)
	@for file in $(s_dir)/*; do \
		if [ -f "$$file" ] ; then \
			echo "workning on $$(basename $$file .md).pdf" ; \
			make $(d_dir)/"$$(basename $$file .md)".pdf start_dir=$(start_dir); \
		fi \
	done
	make $(d_dir)/index.html start_dir=$(start_dir)

.PHONY: clean
clean: $(d_dir)
	@for file in $(d_dir)/*; do \
		if [ -f "$$file" ] ; then \
			echo removeing $$file; \
			git rm "$$file" || true ; \
			rm "$$file" ; \
		fi \
	done
