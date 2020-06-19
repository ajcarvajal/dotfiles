{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  system.stateVersion = "20.03"; 

  environment.systemPackages = with pkgs; [
    # system_util
    redshift light actkbd htop powertop

    # base_development
    coreutils wget git lshw clang gnupg
    vim emacs

    # tools
    firefox bat fd alacritty ripgrep

    # languages
    rustc cargo
    python3

    # fonts
    inconsolata
    font-awesome_4
    font-awesome
    powerline-fonts

    # shitty dependencies
    nodejs 

  ];

  users.users.aj = {
    isNormalUser = true;
    home = "/home/aj";
    extraGroups = [ "wheel" "networkmanager" "video"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Proprietary Drivers
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  powerManagement = { 
    cpuFreqGovernor = "powersave"; 
    powertop.enable = true;
    powerDownCommands = "";
    powerUpCommands = "";
  };

  networking = {
    hostName = "nixos";
    useDHCP = false;  # deprecated. Set false and whitelist interfaces
    interfaces.enp0s31f6.useDHCP = true; # ethernet
    interfaces.wlp0s20f3.useDHCP = true; # wireless
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
    synaptics.palmDetect = true;
    desktopManager.xterm.enable = true;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
            dmenu
            i3status-rust
            i3lock
        ];
    };
  }; 

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 20"; } 
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 20"; }  
        # { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l aj -c 'amixer -q set Master toggle'"; }  
        # { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l aj -c 'amixer -q set Master 5%- unmute'"; }  
        # { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l aj -c 'amixer -q set Master 5%+ unmute'"; }  
    ];
  };

  console.useXkbConfig = true;  # swapesc etc will work in tty

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
