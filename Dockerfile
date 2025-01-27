FROM archlinux:latest

ENV name_user='cook-resume'

RUN pacman --sync --refresh --sysupgrade --noconfirm make texlive texlive-langcyrillic python python-pipenv pandoc-cli ttf-liberation && \
useradd ${name_user} --create-home

WORKDIR /home/${name_user}

ARG RESUME

COPY ${RESUME} Makefile ./

ENV RESUME=${RESUME}

RUN RESUME=$(rev <<< ${RESUME} | cut --delimeter=/ --fields=1 | rev)
RUN touch ./{Pipfile,variables.yaml} && chown ${name_user}:${name_user} ./{${RESUME},Makefile,Pipfile,variables.yaml}

USER ${name_user}

RUN pipenv install --python=/usr/bin/python3 pandoc-mustache && \
mktextfm larm1200 && \
mktextfm larm1440 && \
mktextfm larm1728 && \
chmod 400 Makefile ${RESUME}

ENTRYPOINT [ "pipenv", "run", "make", "resume=${RESUME}" ]
