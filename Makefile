.PHONY: force

source := ${resume}
target != basename -s.md ${resume}
target := $(addsuffix .pdf, ${target})
date_build != date '+%d.%m.%y'

${target}: variables.yaml ${source}
	pandoc \
	${source} \
	--output=${target} \
	--variable=papersize:A4 \
	--variable=mainfont:'Latin Modern' \
	--variable=colorlinks \
	--variable=linkstyle:bold \
	--variable=urlcolor:NavyBlue \
	--variable=geometry:margin=1in \
	--pdf-engine=pdflatex \
	--filter=pandoc-mustache

variables.yaml: force
	echo "\"date_build\": ${date_build}" > variables.yaml

force:
