# Terminal helpers for the rice.

export EDITOR="hx"
export VISUAL="hx"

alias h="hx"
alias he="hx ."
alias browse="browsh"
alias web="browsh"
alias cmatrix="cmatrix -C magenta"
alias t="tmux"
alias ta="tmux attach"
alias tls="tmux ls"
alias rice="~/.dotfiles/tmux/rice-session.sh"

ghx() {
  ghostty --title Helix -e hx "$@"
}

gbrowse() {
  if [ "$#" -eq 0 ]; then
    ghostty --title Browsh -e browsh
  else
    ghostty --title Browsh -e browsh "$@"
  fi
}

gtmux() {
  ghostty --title Ghostty -e zsh -lc "~/.dotfiles/tmux/rice-session.sh"
}
