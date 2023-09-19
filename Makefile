.PHONY: force

NAME ?= resume

name != echo ${NAME} | tr A-Z a-z | tr ' ' '-'
source := ${name}.md
date_build != date '+%d.%m.%y'

$(name).pdf: variables.yaml $(source)
	pandoc \
	$(source) \
	-o $(name).pdf \
	-V mainfont='Latin Modern' \
	-V colorlinks \
	-V urlcolor=NavyBlue \
	-V geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(date_build)" > variables.yaml

force:
