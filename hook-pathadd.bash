[[ -n "${BASH_VERSION}" ]] && {
  __iife() {
    unset __iife
    local projdir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    [[ "$(type -t pathadd.append)" != 'function' ]] && return

    DIM_PULL_BINDIR="${DIM_PULL_BINDIR:-${projdir}/bin}"
    [[ -z "$(bash -c 'echo ${DIM_PULL_BINDIR+x}')" ]] \
      && export DIM_PULL_BINDIR

    pathadd.append "${DIM_PULL_BINDIR}"
  } && __iife
}
