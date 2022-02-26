#!/usr/bin/env bash

THE_SCRIPT="${BASH_SOURCE[0]}"
THE_SCRIPT_NAME="$(basename "${THE_SCRIPT}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${THE_SCRIPT}")")/..")"

declare -A OPTS=(
  [listfiles]=
  [page_size]=1
  [remove]=0
  [imgs]=
  [help]=0
)

. "${TOOL_DIR}/assets/opts.inc.sh"

[[ ${OPTS[help]} -eq 1 ]] && {
  . "${TOOL_DIR}/assets/help.inc.sh"
  exit
}

while read -r f; do
  [[ ! -f "${f}" ]] && {
    echo "Listfile '${f}' file not found!" >&2
    continue
  }

  # parse listfile
  OPTS[imgs]+="${OPTS[imgs]:+$'\n'}"
  OPTS[imgs]+="$(while read -r i; do
    [[ "${i:0:1}" == '#' ]] && continue
    [[ -n "${i}" ]] && echo "${i}"
  done < "${f}")"
done <<< "${OPTS[listfiles]}"

# for o in "${!OPTS[@]}"; do
#   echo "${o} = ${OPTS[${o}]}"
# done

while read -r img_name; do
  [[ -z "${img_name}" ]] && continue

  base_url=https://registry.hub.docker.com/v2/repositories
  if ! grep -q '\/' <<< "${img_name}"; then
    base_url=https://hub.docker.com/v2/repositories/library
  fi
  tags_url="${base_url}/${img_name}/tags?page_size=${OPTS[page_size]}"

  tags="$(
    curl -s "${tags_url}" 2> /dev/null \
    | grep -Po '"name"\s*:\s*"[^"]+"' \
    | sed -E 's/.*:\s*"([^"]+)"$/\1/g'
  )"

  if [[ -z "${tags}" ]]; then
    echo "No tags found for '${img_name}'" >&2
    continue
  fi

  existing_imgs="$(
    docker image ls -f reference="${img_name}" \
      --format '{{ .Repository }}:{{ .Tag }}'
  )"

  for t in ${tags}; do
    img="${img_name}:${t}"
    img_exists=0
    if grep -Fxq "${img}" <<< "${existing_imgs}"; then
      img_exists=1
    fi

    docker image pull "${img}"

    [[ ${img_exists} -eq 0 ]] \
    && [[ ${OPTS[remove]} -eq 1 ]] \
    && docker image rm "${img}"
  done
done <<< "${OPTS[imgs]}"
