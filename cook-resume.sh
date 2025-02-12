#!/usr/bin/env sh

if [ ! -f "${1}" ]; then
  echo "Specified file doesn't exist."
  exit 0
fi

if [ "$(file --brief "${1}")" != 'ASCII text' ]; then
  echo "Unsupported file format."
  exit 0
fi

resume="$(echo "${1}" | rev | cut --delimiter='/' --fields=1 | rev)"

docker build --tag cook-resume --build-arg RESUME="${resume}" "$(pwd)/"

if [ "$(docker container ls --all --quiet --filter 'name=cook-resume' | wc --lines)" -ge 1 ]; then
  docker rm cook-resume
fi

resume=$(basename --suffix='.md' "${resume}").pdf

docker run --name=cook-resume --interactive --tty cook-resume && \
docker cp "cook-resume:/home/cook-resume/${resume}" "./"
