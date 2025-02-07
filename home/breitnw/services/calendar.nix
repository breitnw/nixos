{ config, lib, ... }:

{
  options = {
    modules.calendar = {
      account = lib.mkOption {
        type = lib.types.str;
        default = "breitling.nw@gmail.com";
      };
      sync_base_dir = lib.mkOption {
        type = lib.types.str;
        default = "~/Documents/org/calendar";
      };
      calendar_ids = lib.mkOption {
        default = {
          classes =
            "3ab44d6d3e28cb0ce544e7d7cd14d54a97e480b0a2da856694ce2faaa103d7c4@group.calendar.google.com";
          clubs =
            "2775ee1da85fe35cc26eaade1f59174c174687e18b8e3054769bbc04323b758a@group.calendar.google.com";
          d65 =
            "4f3194d3ac674a551f62451cc81efc2313ec6e64856974f84bc2f6755d71be20@group.calendar.google.com";
          meetings = "nqaiua9309tlo3n42mlj0k093k@group.calendar.google.com";
          stuff =
            "c0206387290a16bd2f4b5de67d44019d0025c8e761abd19e2d92af07a25555dd@group.calendar.google.com";
        };
      };
    };
  };
  config = let
    cfg = config.modules.calendar;
    client_id_path =
      config.sops.secrets."accounts/calendar/${cfg.account}/client_id".path;
    client_secret_path =
      config.sops.secrets."accounts/calendar/${cfg.account}/client_secret".path;
    calendar_alist = "'(" + (lib.concatStringsSep " " (lib.mapAttrsToList
      (name: value: ''("${value}" . "${cfg.sync_base_dir}/${name}.org")'')
      cfg.calendar_ids)) + ")";

  in {
    programs.emacs.extraConfig = ''
      (require 'plstore)
      (add-to-list 'plstore-encrypt-to "962CAADE7EEEA096")

      (setq org-gcal-client-id (doom-file-read "${client_id_path}")
            org-gcal-client-secret (doom-file-read "${client_secret_path}")
            org-gcal-fetch-file-alist ${calendar_alist})
    '';
  };
}
