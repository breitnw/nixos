
# nix-shell: currently running nix-shell
prompt_nix_shell() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    if [[ -n $NIX_SHELL_PACKAGES ]]; then
      local package_names=""
      local packages=($NIX_SHELL_PACKAGES)
      for package in $packages; do
        package_names+=" ${package##*.}"
      done
      echo -n " %{$fg[green]%}[$package_names ]%{$reset_color%}"
    elif [[ -n $name ]]; then
      local cleanName=${name#interactive-}
      cleanName=${cleanName#lorri-keep-env-hack-}
      cleanName=${cleanName%-environment}
      echo -n "%{$fg[magenta]%}[ $cleanName ]%{$reset_color%}"
    else # The nix-shell plugin isn't installed or failed in some way
      echo -n " %{$fg[red]%}nix-shell []%{$reset_color%}"
    fi
  fi
}

# Copied and modified from the oh-my-zsh theme from geoffgarside
# Red server name, green cwd, blue git status

PROMPT='%{$fg[red]%}%m%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}$(git_prompt_info) %(!.#.$) '
RPROMPT='$(prompt_nix_shell)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
