.PHONY: force

NAME ?= resume

name != echo ${NAME} | tr A-Z a-z | tr ' ' '-'
source := ${name}.md
date_build != date '+%d.%m.%y'

$(name).pdf: variables.yaml $(source)
	pandoc \
	$(source) \
	--output=$(name).pdf \
	--variable=mainfont:'Latin Modern' \
	--variable=colorlinks \
	--variable=urlcolor:NavyBlue \
	--variable=geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(date_build)" > variables.yaml

force:
