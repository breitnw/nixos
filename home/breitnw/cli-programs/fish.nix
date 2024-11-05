{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # nix-shell support for fish
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      # configure PATH
      fish_add_path ~/.config/emacs/bin
    '';
  };
}
