# Terminal helpers for the rice.

export EDITOR="hx"
export VISUAL="hx"

alias h="hx"
alias he="hx ."
alias browse="browsh"
alias web="browsh"
alias cmatrix="cmatrix -aB -u 3 -C yellow"
alias cmatrix-lain="cmatrix -aB -u 3 -C yellow"
alias cmatrix-lain-yellow="cmatrix -aB -u 3 -C yellow"
alias cmatrix-lain-red="cmatrix -aB -u 3 -C red"
alias cmatrix-japanese="cmatrix -aBc -u 3 -C white"
alias cmatrix-lain-rainbow="cmatrix -abc -u 3 -r"
alias t="tmux"
alias ta="tmux attach"
alias tls="tmux ls"
alias rice="~/.dotfiles/tmux/rice-session.sh"
alias home-rice="~/.dotfiles/launch-lain-home.sh"
alias lain-wallpaper="~/.dotfiles/set-lain-wallpaper.sh"

if [[ -z "$FASTFETCH_SHOWN" && -o interactive && -z "$INSIDE_EMACS" && "$TERM_PROGRAM" != "vscode" && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

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
