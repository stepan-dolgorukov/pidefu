FROM archlinux:latest

ENV name_user='cook-resume'

RUN pacman --sync --refresh --sysupgrade --noconfirm make texlive texlive-langcyrillic python python-pipenv pandoc-cli && \
useradd ${name_user} --create-home

WORKDIR /home/${name_user}

ARG RESUME

COPY ${RESUME} Makefile ./

RUN chown ${name_user}:${name_user} Makefile ${RESUME}

USER ${name_user}

RUN pipenv install pandoc-mustache && \
mktextfm larm1200 && \
mktextfm larm1440 && \
mktextfm larm1728 && \
chmod 400 Makefile ${RESUME}

ENV RESUME=${RESUME}

ENTRYPOINT [ "pipenv", "run", "make", "resume=$(cut -d/ -f1 <<< ${RESUME})" ]
