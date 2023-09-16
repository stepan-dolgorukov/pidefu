.PHONY: force

DATE_BUILD != date '+%d.%m.%y'

resume.pdf: variables.yaml resume.md
	pandoc \
	resume.md \
	-o resume.pdf \
	-V mainfont='Latin Modern' \
	-V colorlinks \
	-V urlcolor=NavyBlue \
	-V geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": $(DATE_BUILD)" > variables.yaml

force:
