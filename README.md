# breitnw's nixos config
This repo contains my configuration for NixOS on Asahi Linux. It's obviously meant for my personal use, but there might 
useful nuggets here and there if you want to reference it in your own config :)

## structure and design
I use a flake to manage my NixOS and home-manager configurations. Home-manager handles installation and configuration of pretty much all the apps available to the user, while NixOS handles hardware-specific configuration. My general rule of thumb is that if it shouldn't be on every computer I deploy my config to, it shouldn't be configured with home-manager. 

## features
- Secrets management with [sops-nix](https://github.com/Mic92/sops-nix)
- Multi-account gmail integration with [mu4e](https://github.com/emacsmirror/mu4e), [mbsync](https://github.com/gburd/isync), and [msmtp](https://github.com/marlam/msmtp), for use with [my doom emacs config](https://github.com/breitnw/doom)
- Asahi linux support with [nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon), including touchbar support with [tiny-dfr](https://github.com/WhatAmISupposedToPutHere/tiny-dfr)
- XFCE desktop environment support
- Full theming support with [nix-colors](https://github.com/Misterio77/nix-colors)