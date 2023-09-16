.PHONY: force

NAME ?= resume
SOURCE := $(NAME).md
DATE_BUILD != date '+%d.%m.%y'

$(NAME).pdf: variables.yaml $(SOURCE)
	pandoc \
	$(SOURCE) \
	-o $(NAME).pdf \
	-V mainfont='Latin Modern' \
	-V colorlinks \
	-V urlcolor=NavyBlue \
	-V geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(DATE_BUILD)" > variables.yaml

force:
