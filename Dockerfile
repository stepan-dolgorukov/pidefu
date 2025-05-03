FROM archlinux:latest@sha256:ce4dddea70099cc8360478d162e478997420185683ce9de88223c3f316c17c1e

ENV name_user='buildon'

RUN pacman --sync --refresh --sysupgrade --noconfirm make texlive \
    texlive-langcyrillic python python-pipenv pandoc-cli ttf-liberation && \
    useradd ${name_user} --create-home

WORKDIR /home/${name_user}

COPY Makefile ./

RUN touch ./{Pipfile,variables.yaml} && \
    chown ${name_user}:${name_user} ./{${RESUME},Makefile,Pipfile,variables.yaml}

RUN pipenv install --python=/usr/bin/python3 pandoc-mustache && \
    mktextfm larm1200 && \
    mktextfm larm1440 && \
    mktextfm larm1728 && \
    chmod 400 Makefile ${RESUME}

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
