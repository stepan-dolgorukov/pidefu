FROM archlinux:latest@sha256:ce4dddea70099cc8360478d162e478997420185683ce9de88223c3f316c17c1e

ENV name_user='buildon'

RUN pacman --sync --refresh --sysupgrade --noconfirm make texlive \
    texlive-langcyrillic python python-pipenv pandoc-cli ttf-liberation && \
    useradd ${name_user} --create-home

WORKDIR /home/${name_user}

COPY Makefile Pipfile Pipfile.lock ./

RUN touch ./variables.yaml && \
    chown ${name_user}:${name_user} ./{Makefile,Pipfile,Pipfile.lock,variables.yaml}

RUN pipenv sync --python=/usr/bin/python3 && \
    mktextfm larm1200 && \
    mktextfm larm1440 && \
    mktextfm larm1728 && \
    chmod 400 Makefile

CMD for file_markdown in $(find . -iname '*.md' -o \
                                  -iname '*.mdwn' -o \
                                  -iname '*.mkd' -o \
                                  -iname '*.mkdn' -o \
                                  -iname '*.mdown' -o \
                                  -iname '*.markdown' ); do \
        pipenv run make resume=${file_markdown}; \
    done; \
    test "${?}" -ne 0 && exit 1 || \
    for file_pdf in $(find . -iname '*.pdf'); do \
        mv --force ${file_pdf} ./.transfer; \
    done
