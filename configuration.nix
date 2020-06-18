{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  system.stateVersion = "20.03"; 

  environment.systemPackages = with pkgs; [
    wget vim firefox lshw git 
    rustc cargo nodejs bat 
    inconsolata fd alacritty
    emacs ripgrep coreutils
    clang gnupg actkbd light
    font-awesome python3
    guile redshift
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

  networking = {
    hostName = "nixos";
    useDHCP = false;  # deprecated. Set false and whitelist interfaces
    interfaces.enp0s31f6.useDHCP = true; # ethernet
    interfaces.wlp4s0.useDHCP = true;    # wireless
    networkmanager.enable = true;        # KDE nm uses this
    nameservers = [ "1.1.1.1" ];         # default DNS server    
    wireless.networks = {
        poop = {
            psk = "9257cf6352d011a4ddd629dd386991ac2e15048c25310477e15040fc6d7b9cb3";
        };
    };
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
    ];
  };

  console.useXkbConfig = true;  # swapesc etc will work in tty

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;
}
