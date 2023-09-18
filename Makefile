.PHONY: force

NAME ?= resume
source := $(NAME).md
date_build != date '+%d.%m.%y'

$(NAME).pdf: variables.yaml $(source)
	pandoc \
	$(source) \
	-o $(NAME).pdf \
	-V mainfont='Latin Modern' \
	-V colorlinks \
	-V urlcolor=NavyBlue \
	-V geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(date_build)" > variables.yaml

force:
