{config, ...}:

# Enable helpful DBus services
{
  services.dbus.enable = true;

  # system functionality
  services.upower.enable = config.powerManagement.enable;
  services.system-config-printer.enable = config.services.printing.enable;
  services.blueman.enable = config.hardware.bluetooth.enable; # bluetooth
  services.libinput.enable = true; # input configuration
  services.accounts-daemon.enable = true;

  # file picker
  services.udisks2.enable = true; # disk access
  services.gvfs.enable = true; # devices, trash, etc
  services.tumbler.enable = true; # thumbnails for documents

  # xorg/xfce-specific 
  programs.xfconf.enable = true; # for XFCE configuration
  services.colord.enable = true; # color management for xorg
}
