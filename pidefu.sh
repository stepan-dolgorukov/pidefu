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
  echo "A content of the file isn't in Markdown language."
  exit 0
fi

catalog_transfer="$(mktemp --directory -p ./ -t .transfer.XXXXXXXX)"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to create transfer catalog."
  exit 1
fi

cp --verbose "${1}" "${catalog_transfer}"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to copy file to the catalog."
  exit 1
fi

docker build --tag pidefu "$(pwd)/"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Unsuccessfull image build."
  rm --recursive --force "${catalog_transfer}"
  exit "${exit_code}"
fi

docker run \
  --interactive=true \
  --tty=true \
  --volume "${catalog_transfer}":/home/buildon/.transfer/ \
  pidefu

exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to run container."
  rm --recursive --force "${catalog_transfer}"
  exit "${exit_code}"
fi
