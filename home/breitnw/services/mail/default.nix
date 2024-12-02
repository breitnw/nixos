# This file will handle ALL mail configuration, including mu4e config for emacs.
# No manual emacs configuration is necessary.

# The following modules are enabled and configured:
# - mu, for indexing the maildir
# - mu4e, for viewing mail in emacs
# - msmtp, for sending mail
# - mbsync, for fetching mail

{ pkgs, config, lib, ... }:

let cfg = config.modules.mail;

in {
  options = {
    modules.mail = {
      enable = lib.mkEnableOption "Whether to enable mail syncing";
      accounts = lib.mkOption {
        description = ''
          The accounts to create mail contexts for.

          These should be the email _aliases_ to add, not the primary
          addresses. If the email is an alias. this should be specified
          with the `isAliasOf` field. The primary address is used to
          fetch mail, while the alias is used to create the mu4e context
          to send and view it.
        '';
        default = {
          "School" = {
            primary = true;
            gmail = true;
            mainAddress = "NicholasBreitling2027@u.northwestern.edu";
            makeMainAddressContext = false;
            aliases = [ "breitnw@u.northwestern.edu" ];
            realName = "Nick Breitling";
          };
          "Personal" = {
            primary = false;
            gmail = true;
            mainAddress = "breitling.nw@gmail.com";
            realName = "Nick Breitling";
          };
        };
        type = with lib;
          types.attrsOf (types.submodule {
            options = {
              primary = mkOption {
                description = "Whether this is the primary email account";
                type = types.bool;
              };
              gmail = mkOption {
                description = "Whether this is a gmail account.";
                type = types.bool;
              };
              mainAddress = mkOption {
                description =
                  "The main email address for this account (not an alias)";
                type = types.str;
              };
              makeMainAddressContext = mkOption {
                description = ''
                  Whether to create a mail context for this account's main address.

                  Set this to `false` if you only want to make contexts for this
                  account's aliases.
                '';
                type = types.bool;
                default = true;
              };
              aliases = mkOption {
                description = ''
                  A list of aliases for this account's main address.

                  It is assumed that adding an alias to this list means the
                  user wants to send mail from said alias. As such, a new
                  context is generated for each alias in this list.
                '';
                type = types.listOf types.str;
                default = [ ];
              };
              realName = mkOption {
                description = "My real name, to use in signatures and such";
                type = types.str;
              };
            };
          });
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # enable mbsync to sync messages
    programs.mbsync.enable = true;

    # enable mu to index maildir
    programs.mu.enable = true;

    # enable msmtp to send mail
    programs.msmtp.enable = true;

    # enable mu4e (emacs mail viewer)
    # mu doesn't install mu4e by default now, and installing the doom
    # module doesn't either. This seems to be the only thing that works
    programs.emacs.extraPackages = epkgs: [ epkgs.mu4e ];

    programs.emacs.extraConfig = let
      # the package set used by this emacs install
      emacsPackages = pkgs.emacsPackagesFor config.programs.emacs.package;

      # expression to add mu4e to the emacs load path
      # also TODO: will this break if mu4e is updated? will it work if we just add the `elpa`
      # folder to the load path?
      load_path_expr = ''
        (add-to-list 'load-path "${emacsPackages.mu4e}/share/emacs/site-lisp/elpa/mu4e-1.12.5")
      '';

      # the contexts for mu4e to load
      contexts = lib.concatMapAttrs (name: value:
        let
          addresses =
            (lib.optional (value.makeMainAddressContext) value.mainAddress)
            ++ value.aliases;
        in lib.genAttrs addresses (address:
          if builtins.length addresses == 1 then
            name
          else
            "${name} [${address}]")) cfg.accounts;

      # expression to define the contexts for mu4e to load (one for each
      # alias and main address, as desired). uses the address as the key,
      # and the name of the context as the value
      contexts_expr = "(defvar mail-accounts '(" + lib.concatStringsSep " "
        (lib.mapAttrsToList (name: value: ''("${value}" . "${name}")'')
          contexts) + "))";

      # expression to load mu4e variables
      load_expr = ''
        (load "${./mail.el}")
      '';

    in load_path_expr + contexts_expr + load_expr;

    # configure email accounts
    accounts.email = {
      maildirBasePath = "${config.home.homeDirectory}/Mail";

      accounts = lib.attrsets.mapAttrs (name: value: {
        inherit (value) primary aliases realName;
        # the key is the (non-alias) address
        address = value.mainAddress;
        # the location of the password in sops is "accounts/email/{address}", where {address}
        # is the address field above
        passwordCommand = "cat ${
            config.sops.secrets."accounts/email/${value.mainAddress}".path
          }";
        # handles userName, imap.host, and imap.port
        flavor = lib.mkIf value.gmail "gmail.com";

        # the default gmail folders are always in the same place
        # TODO add spam folder?
        folders = {
          inbox = "Inbox";
          drafts = "Drafts";
          sent = "Sent";
          trash = "Trash";
        };

        # apps...
        # for viewing mail
        mu.enable = true;

        # for sending mail
        msmtp.enable = true;

        # for receiving mail
        mbsync = {
          enable = true;
          create = "both"; # sync mailbox creations
          # expunge = "both"; # sync message expunges (permanent deletion)
          remove = "both"; # sync mailbox deletions
          groups = lib.mkIf value.gmail {
            # filed messages
            "Filed".channels."All" = {
              patterns = [ "*" "![Gmail]*" "!INBOX" ];
              nearPattern = "Filed/";
              extraConfig.Create = "near";
            };
            # default gmail folders
            "Gmail".channels = {
              "Inbox" = {
                farPattern = "INBOX";
                nearPattern = "Inbox";
                extraConfig.Create = "near";
              };
              "Drafts" = {
                farPattern = "[Gmail]/Drafts";
                nearPattern = "Drafts";
                extraConfig.Create = "near";
              };
              "Sent" = {
                farPattern = "[Gmail]/Sent Mail";
                nearPattern = "Sent";
                extraConfig.Create = "near";
              };
              "Trash" = {
                farPattern = "[Gmail]/Trash";
                nearPattern = "Trash";
                extraConfig.Create = "near";
              };
              "Spam" = {
                farPattern = "[Gmail]/Spam";
                nearPattern = "Spam";
                extraConfig.Create = "near";
              };
            };
          };
        };
      }) cfg.accounts;
    };
  };
}
