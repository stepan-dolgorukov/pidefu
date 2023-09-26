.PHONY: force

RESUME ?= resume

source := ${RESUME}.md
date_build != date '+%d.%m.%y'

$(RESUME).pdf: variables.yaml $(source)
	pandoc \
	$(source) \
	--output=$(RESUME).pdf \
	--variable=mainfont:'Latin Modern' \
	--variable=colorlinks \
	--variable=urlcolor:NavyBlue \
	--variable=geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(date_build)" > variables.yaml

force:
