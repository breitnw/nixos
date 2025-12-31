> The term "system", as it is used in this document and across my configuration, is subject to be changed to "platform" to emphasize hardware capabilities. However, "system" should still be used to refer to a _pairing between a platform and a host_, such as in the name of the `systems` attrset in `flake.nix`.

> Also note that the name of the system, not the host, has to be used as the networking hostname due to the limitations of NixOS. Although each NixOS configuration represents an entire system, the attributes holding these configurations must be named according to a specific networking hostname.

# breitnw's nixos config
This repo contains my configuration for NixOS on Asahi Linux. It's obviously meant for my personal use, but there might be useful nuggets here and there if you want to reference it in your own config :)

## structure and design
I use a flake to manage my NixOS and home-manager configurations. Home-manager handles installation and configuration of pretty much all the apps available to the user, while NixOS handles hardware-specific configuration. My general rule of thumb is that if something can be configured at the user-level, it should. 

To keep everything organized, I've settled on a few design patterns for defining and configuring options:

- Outside of `sysinfo` (see [systems and hosts](#systems-and-hosts)), all options that I define are within the `modules` or `utils` attrsets. In general, an option should go on `modules` if it directly affects the home-manager configuration, and `utils` if it supplies a utility for other modules. 
- For modules that define a lot of options, a file named `options.nix` should be created to handle these options' declaration and use. Meanwhile, the same directory's `default.nix` should import `options.nix` and configure said options. The `xfce` and `mail` modules demonstrate this pattern. 

### systems and hosts
Within my configuration, I separate the notion of a "system" from a "host". A system represents all of the immutable capabilities and characteristics of a device (including the architecture, display, internal keyboard, graphics capabilities, etc). The `hardware-configuration.nix` file generated with NixOS **is also part of the system!** A host, on the other hand, represents the device's observable, configured behaviors. 

The rationale behind this design is to take the reproducibility of NixOS one step further. By separating low-level details from high-level behaviors, a host configuration can be deployed to any computer _regardless of the system_. For example, the host configuration might toggle between DisplayLink and DisplayPort depending on whether the system supports DP Alt Mode, but to the user, the observable behavior when using an external display remains roughly the same. 

Currently, my two systems, "core" and "lite", correspond with the "core" and "lite" hosts, as outlined in `flake.nix`:

``` nix
systems = {
  core = {
    sysinfo = ./systems/core/system.nix;
    hardware-config = ./systems/core/hardware-configuration.nix;
    host-config = ./hosts/core.nix;
    user-config = ./users/breitnw-at-core.nix;
  };
  lite = {
    sysinfo = ./systems/lite/system.nix;
    hardware-config = ./systems/lite/hardware-configuration.nix;
    host-config = ./hosts/lite.nix;
    user-config = ./users/breitnw-at-lite.nix;
  };
};
```

However, this could easily be modified to give both systems the functionality of a new `awesomehost` host, configured in `hosts/awesomehost.nix` and `users/breitnw-at-awesomehost.nix`.

``` nix
systems = {
  core = {
    sysinfo = ./systems/core.nix;
    hardware-config = ./systems/core/hardware-configuration.nix;
    host-config = ./hosts/awesomehost.nix;
    user-config = ./users/breitnw-at-awesomehost.nix;
  };
  lite = {
    sysinfo = ./systems/lite.nix;
    hardware-config = ./systems/lite/hardware-configuration.nix;
    host-config = ./hosts/awesomehost.nix;
    user-config = ./users/breitnw-at-awesomehost.nix;
  };
};
```
Concretely, all system-dependent information is configured in the `systems/` directory, while all host-dependent info is configured in the `hosts/` directory. Each system consists of the `hardware-configuration.nix` generated upon NixOS installation, alongside a `system.nix` that provides details on the keyboard, display, and other hardware characteristics. A system's `system.nix` should implement the interface provided by `systems/options.nix`. These options are threaded through to *both NixOS and Home-Manager*, which can use them to implement desired behaviors in a host-agnostic way.

## features
- XFCE, Niri, and Sway environments, each with custom theme generation based on [nix-colors](https://github.com/Misterio77/nix-colors). Themes are also generated for certain apps, including emacs, alacritty, qutebrowser, and firefox
- Multi-account gmail integration with [mu4e](https://github.com/emacsmirror/mu4e), [mbsync](https://github.com/gburd/isync), and [msmtp](https://github.com/marlam/msmtp), for use with [my doom emacs config](https://github.com/breitnw/doom)
- Calendar integration with [khal](https://github.com/pimutils/khal)
- Asahi linux support with [nixos-apple-silicon](https://github.com/tpwrules/nixos-apple-silicon), including [touchbar functionality](https://github.com/WhatAmISupposedToPutHere/tiny-dfr)
- An awesome zsh prompt displaying nix-shell and hm-ricing-mode status
- Global TOML keybind configuration for compatibility with various layouts (this one is a bit of a work in progress!)
- Secrets management with [sops-nix](https://github.com/Mic92/sops-nix)
- Thoughtful design with support for multiple systems, hosts, and users
