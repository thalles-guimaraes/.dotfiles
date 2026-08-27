# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{

  # ---------------------------------------------------------------------------
  # Bootloader
  # ---------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # ---------------------------------------------------------------------------
  # Rede
  # ---------------------------------------------------------------------------

  networking.networkmanager.enable = true;


  # ---------------------------------------------------------------------------
  # Localização / Idioma
  # ---------------------------------------------------------------------------

  time.timeZone = "America/Sao_Paulo";

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


  # ---------------------------------------------------------------------------
  # Teclado
  # ---------------------------------------------------------------------------

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


  # ---------------------------------------------------------------------------
  # Usuário
  # ---------------------------------------------------------------------------

  users.users."thallesnote" = {
    isNormalUser = true;
    description = "thallesnote";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [ ];
  };


  # ---------------------------------------------------------------------------
  # Pacotes proprietários
  # ---------------------------------------------------------------------------

  nixpkgs.config.allowUnfree = true;


  # ---------------------------------------------------------------------------
  # Memória / Swap
  # ---------------------------------------------------------------------------

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


  # ---------------------------------------------------------------------------
  # Greetd / TuiGreet
  # ---------------------------------------------------------------------------

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


  # ---------------------------------------------------------------------------
  # Bluetooth
  # ---------------------------------------------------------------------------

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;


  # ---------------------------------------------------------------------------
  # Segurança / Polkit
  # ---------------------------------------------------------------------------

  security.polkit.enable = true;


  # ---------------------------------------------------------------------------
  # Steam
  # ---------------------------------------------------------------------------

  programs.steam.enable = true;


  # ---------------------------------------------------------------------------
  # Thunar
  # ---------------------------------------------------------------------------

  programs.thunar.enable = true;

  # O módulo do Thunar já habilita xfconf automaticamente.
  # Estou mantendo explícito porque você já o utilizava para integração visual.
  programs.xfconf.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;


  # ---------------------------------------------------------------------------
  # Thunar / Xfce - Terminal padrão
  # ---------------------------------------------------------------------------
  #
  # O "Open Terminal Here" do Thunar usa o conceito de
  # TerminalEmulator do Xfce.
  #
  # Esse arquivo equivale ao:
  #
  #   /etc/xdg/xfce4/helpers.rc
  #
  # e define Alacritty como terminal padrão para todos os usuários
  # que não sobrescreverem essa configuração em ~/.config/xfce4/helpers.rc.
  #

  environment.etc."xdg/xfce4/helpers.rc".text = ''
    TerminalEmulator=alacritty
  '';


  # Os helpers do Xfce, incluindo alacritty.desktop, ficam em:
  #
  #   share/xfce4/helpers/
  #
  # Como não estamos instalando o desktop Xfce completo, precisamos
  # explicitamente expor esse diretório no ambiente do sistema.
  #
  environment.pathsToLink = [
    "/share/xfce4"
  ];


  # ---------------------------------------------------------------------------
  # Shell
  # ---------------------------------------------------------------------------

  programs.fish.enable = true;

  users.users.thallesnote.shell = pkgs.fish;


  # ---------------------------------------------------------------------------
  # Hyprland
  # ---------------------------------------------------------------------------

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;


  # ---------------------------------------------------------------------------
  # Fonts
  # ---------------------------------------------------------------------------

  fonts.packages = with pkgs; [
    fira-code
    jetbrains-mono
    d2coding
    font-awesome
    nerd-fonts.jetbrains-mono
  ];


  # ---------------------------------------------------------------------------
  # Pacotes instalados no sistema
  # ---------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [

    # -------------------------------------------------------------------------
    # Hyprland
    # -------------------------------------------------------------------------

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
    heroic


    # -------------------------------------------------------------------------
    # Thunar / Xfce
    # -------------------------------------------------------------------------

    # Fornece o comando:
    #
    #   exo-open
    #
    xfce4-exo

    # Fornece os helpers do Xfce, incluindo:
    #
    #   share/xfce4/helpers/alacritty.desktop
    #
    xfce4-settings

    # Instalamos Alacritty também no sistema porque agora ele é
    # o TerminalEmulator padrão global.
    alacritty


    # -------------------------------------------------------------------------
    # Apps gerais
    # -------------------------------------------------------------------------

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
    hydralauncher
    kdePackages.okular
    gthumb


    # -------------------------------------------------------------------------
    # Outros
    # -------------------------------------------------------------------------

    pavucontrol
    iw
    vim
    wget
  ];


  # ---------------------------------------------------------------------------
  # SwayOSD / Udev
  # ---------------------------------------------------------------------------

  services.udev.packages = [
    pkgs.swayosd
  ];


  # ---------------------------------------------------------------------------
  # SSH
  # ---------------------------------------------------------------------------

  # services.openssh.enable = true;


  # ---------------------------------------------------------------------------
  # Firewall
  # ---------------------------------------------------------------------------

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;


  # ---------------------------------------------------------------------------
  # NixOS State Version
  # ---------------------------------------------------------------------------

  system.stateVersion = "26.05";


  # ---------------------------------------------------------------------------
  # Nix / Flakes
  # ---------------------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # ---------------------------------------------------------------------------
  # Garbage Collector
  # ---------------------------------------------------------------------------

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}