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

catalog_root="$(dirname "${0}")"

catalog_build="$(mktemp --directory -t pidefu.XXXXXXXX)"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to create build catalog."
  exit 1
fi

cp --verbose "${1}" "${catalog_build}"
exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to copy file to the catalog."
  rm --recursive --force "${catalog_build}"
  exit 1
fi

make \
  --directory="${catalog_build}" \
  --file="$(realpath "${catalog_root}/Makefile")" \
  resume="$(basename "${1}")"

exit_code="${?}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to build the document."
  rm --recursive --force "${catalog_build}"
  exit "${exit_code}"
fi

for file_pdf in "${catalog_build}"/*.pdf; do
  mv --verbose --force "${file_pdf}" ./
done

exit_code="${?}"

rm --recursive --force "${catalog_build}"

if [ "${exit_code}" -ne 0 ]; then
  echo "Fail to move built documents."
  exit "${exit_code}"
fi
