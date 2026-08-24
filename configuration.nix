# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

    console = {
    keyMap = "br-abnt2";

    colors = [
      "303446"
      "e78284"
      "a6d189"
      "e5c890"
      "8caaee"
      "ca9ee6"
      "81c8be"
      "c6d0f5"
      "626880"
      "ea999c"
      "a6d189"
      "e5c890"
      "8caaee"
      "f4b8e4"
      "99d1db"
      "ffffff"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."thallesnote" = {
    isNormalUser = true;
    description = "thallesnote";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- Memória / Swap ---

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB, valor em MiB
      priority = 10;
    }
  ];

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };


  # --- Greetd / TuiGreet ---
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --remember-session \
            --cmd 'start-hyprland --' \
            --theme 'border=magenta;text=white;prompt=magenta;time=blue;action=magenta;button=magenta;container=black;input=white;title=magenta;greet=magenta;'
        '';

        user = "greeter";
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Liga o bluetooth automaticamente no boot
  };


  security.polkit.enable = true;
  programs.steam.enable = true;
  programs.thunar.enable = true;
  
  # Thunar pegar cor
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  
  programs.fish.enable = true;
  services.blueman.enable = true;


  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  users.users.thallesnote.shell = pkgs.fish;

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    d2coding
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # hyprland
    hyprpaper
    hypridle
    libnotify
    wl-clipboard
    cliphist
    grim
    slurp
    hyprpolkitagent
    networkmanagerapplet
    swayosd
    
    # Apps gerais
    anki
    spotify
    obsidian
    qbittorrent
    xdg-utils
    eog
    mpv
    gnome-calculator
    file-roller
    btop

    # Outros
    pavucontrol
    iw
    vim
    wget
  ];

  services.udev.packages = [ pkgs.swayosd ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly"; # O sistema tentará rodar a limpeza 1x por semana
    options = "--delete-older-than 7d"; # Apaga tudo que for mais velho que 7 dias
  };

}
