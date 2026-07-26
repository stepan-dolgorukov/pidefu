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

catalog_result='./result'

rm --recursive --force "${catalog_result}"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to remove existing result catalog."
  exit 1
fi

mkdir "${catalog_result}"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to create result catalog."
  exit 1
fi

path_source="$(realpath "${1}")"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to resolve a path to the file."
  rm --recursive --force "${catalog_result}"
  exit 1
fi

docker build --tag pidefu "$(pwd)/"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Unsuccessfull image build."
  rm --recursive --force "${catalog_result}"
  exit "${exit_code}"
fi

docker run \
  --interactive=true \
  --tty=true \
  --volume "${path_source}":/home/buildon/"$(basename "${1}")":ro \
  --volume "${catalog_result}":/home/buildon/.transfer/ \
  pidefu

exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to run container."
  rm --recursive --force "${catalog_result}"
  exit "${exit_code}"
fi
