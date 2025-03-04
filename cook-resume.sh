#!/usr/bin/env sh

if [ "${#}" -lt 1 ]; then
  echo "A name of file wasn't specified."
  exit 0
fi

if [ ! -e "${1}" ]; then
  echo "A file with specified name doesn't exist."
  exit 0
fi

if [ ! -f "${1}" ]; then
  echo "Specified file isn't regular."
  exit 0
fi

type_file="$(file --brief "${1}")"

if [ "${type_file}" != 'ASCII text' ] && [ "${type_file}" != 'Unicode text, UTF-8 text' ]; then
  echo "Unsupported file format."
  exit 0
fi

resume="$(echo "${1}" | rev | cut --delimiter='/' --fields=1 | rev)"

docker build --tag cook-resume --build-arg RESUME="${resume}" "$(pwd)/"

exit_code="${?}"

if [ "${exit_code}" != 0 ]; then
  echo "Unsuccessfull image build."
  exit "${exit_code}"
fi

if [ "$(docker container ls --all --quiet --filter 'name=cook-resume' | wc --lines)" -ge 1 ]; then
  docker rm cook-resume
fi

resume="$(basename --suffix='.markdown' "${resume}")"
resume="$(basename --suffix='.mdown' "${resume}")"
resume="$(basename --suffix='.mkdn' "${resume}")"
resume="$(basename --suffix='.mkd' "${resume}")"
resume="$(basename --suffix='.mdwn' "${resume}")"
resume="$(basename --suffix='.md' "${resume}")".pdf

docker run --name=cook-resume --interactive --tty cook-resume && \

exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Unsuccessfull run of a container."
  exit "${exit_code}"
fi

docker cp "cook-resume:/home/cook-resume/${resume}" "./"

