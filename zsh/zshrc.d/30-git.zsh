gitb() {
  git --git-dir="$PWD/.bare" "$@"
}

gitm() {
  git --git-dir="$PWD/main/.git" "$@"
}
