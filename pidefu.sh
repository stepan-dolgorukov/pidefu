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

mkdir --verbose --parents ./build
exit_code="${?}"

if [ "${exit_code}" != 0 ]; then
  echo "Fail to create catalog."
  exit 1
fi

cp --verbose "${1}" ./build
exit_code="${?}"

if [ "${exit_code}" != 0 ]; then
  echo "Fail to create catalog."
  exit 1
fi

docker build --tag pidefu "$(pwd)/"
exit_code="${?}"

if [ "${exit_code}" != 0 ]; then
  echo "Unsuccessfull image build."
  exit "${exit_code}"
fi

docker run \
  --interactive=true \
  --tty=true \
  --volume ./build:/home/buildon/build \
  pidefu

exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to run container."
  exit "${exit_code}"
fi
