{ config, lib, ... }:

# TODO configure emacs in here! maybe?

let
  cfg = config.modules.mail;
in

{
  options = {
    modules.mail = {
      enable = lib.mkEnableOption "Whether to enable mail syncing";
      accounts = lib.mkOption {
        default = {
          "School" = {
            primary = true;
            gmail = true;
            address = "NicholasBreitling2027@u.northwestern.edu";
            aliases = [ "breitnw@u.northwestern.edu" ];
          };
          "Personal" = {
            primary = false;
            gmail = true;
            address = "breitling.nw@gmail.com";
            aliases = [];
          };
        };
        type = with lib; types.attrsOf (types.submodule {
          options = {
            primary = mkOption {
              type = types.bool;
              description = "Whether this is the primary email account";
            };
            gmail = mkOption {
              type = types.bool;
              description = "Whether this is a gmail account.";
            };
            address = mkOption {
              type = types.string;
              description = "The primary email address associated with this account";
            };
            aliases = mkOption {
              type = types.listOf types.string;
              description = "The list of aliases for this account";
              default = [];
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
    programs.emacs.extraPackages = epkgs: [
      epkgs.mu4e
    ];

    # automatically sync with services.mbsync
    # we don't need to do this because emacs should handle it for us
    # services.mbsync = {
    #   enable = true;
    #   frequency = "*:0/5";
    # };

    # configure email accounts
    accounts.email = {
      maildirBasePath = "/home/breitnw/Mail";

      accounts = lib.attrsets.mapAttrs (name: value: {
        inherit (value) primary address aliases;
        # the location of the password in sops is "accounts/email/{address}", where {address}
        # is the address field above
        passwordCommand = "cat ${config.sops.secrets."accounts/email/${value.address}".path}";
        # handles userName, imap.host, and imap.port
        flavor = lib.mkIf value.gmail "gmail.com";
        # my name is always Nick...
        realName = "Nick Breitling";

        # the default gmail folders are always in the same place
        # TODO add spam folder?
        folders = {
          inbox = "Inbox";
          drafts = "Drafts";
          sent = "Sent";
          trash = "Trash";
        };

        # apps...
        # for receiving mail
        mbsync = {
          enable = true;
          create = "both";  # sync mailbox creations
          # expunge = "both"; # sync message expunges (permanent deletion)
          remove = "both";  # sync mailbox deletions
          groups = lib.mkIf value.gmail {
            # custom folders
            "Custom".channels."All" = {
              patterns = [ "*" "![Gmail]*" "!INBOX" ];
              nearPattern = "/";
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
        # for viewing mail
        # configured in emacs
        mu.enable = true;
        # for sending mail
        msmtp.enable = true;

      }) cfg.accounts;
    };
  };
}
