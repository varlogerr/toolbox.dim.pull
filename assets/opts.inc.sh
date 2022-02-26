__iife() {
  unset __iife
  local eopt=0

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      -f|--listfile)  OPTS[listfiles]+="${OPTS[listfiles]:+$'\n'}${2}"; shift ;;
      --listfile=?*)  OPTS[listfiles]+="${OPTS[listfiles]:+$'\n'}${1#*=}" ;;
      -l|--limit)     OPTS[page_size]="${2}"; shift ;;
      --limit=?*)     OPTS[page_size]="${1#*=}" ;;
      -r|--remove)    OPTS[remove]=1 ;;
      -\?|-h|--help)  OPTS[help]=1 ;;
      *)              OPTS[imgs]+="${OPTS[imgs]:+$'\n'}${1}" ;;
    esac
    shift
  done
} && __iife "${@}"
