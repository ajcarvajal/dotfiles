{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  system.stateVersion = "20.03"; 

  environment.systemPackages = with pkgs; [
    wget vim firefox lshw git 
    rustc cargo nodejs bat fd
  ];

  users.users.aj = {
    isNormalUser = true;
    home = "/home/aj";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Proprietary Drivers
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "nixos";
    useDHCP = false;  # deprecated. Set false and whitelist interfaces
    interfaces.enp0s31f6.useDHCP = true; # ethernet
    interfaces.wlp4s0.useDHCP = true;    # wireless
    networkmanager.enable = true;        # KDE nm uses this
    nameservers = [ "1.1.1.1" ];         # default DNS server    
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  programs.bash.shellAliases = {
    fzf = "fzf --preview '`which bat` --color=always --theme=OneHalfDark {}'";
    cfg = "sudoedit /etc/nixos/configuration.nix";
  };
    
  environment.variables = {
    EDITOR="vim";
    PATH="$PATH:~bin";
    BAT_THEME = "DarkNeon";
    FZF_DEFAULT_COMMAND="fd -H --exclude=**/.*/*";
    FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND";
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:swapescape";
    libinput.enable = true;             # touchpad support 
    libinput.naturalScrolling = true;   # reverse scroll direction
    synaptics.horizTwoFingerScroll = true;
    synaptics.scrollDelta = 75;
  }; 

  console.useXkbConfig = true;  # swapesc etc will work in tty

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
}
