{ config, pkgs, inputs, ... }:

let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    size = "standard";
    variant = "frappe";
  };
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # --- Configurações Básicas ---
  home.username = "thallesnote";
  home.homeDirectory = "/home/thallesnote";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # --- Configurações do Git ---
  programs.git = {
    enable = true;
    settings.user = {
      name = "Thalles Guimaraes";
      email = "thalles.guimaraes456@gmail.com";
    };
  };

  # --- Configurações do Dunst ---
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        font = "JetBrainsMono Nerd Font 11"; # Usando a fonte que você já instalou
        
        # Posicionamento e tamanho
        width = 300;
        height = 300;
        offset = "20x20";
        origin = "top-right";
        notification_limit = 5;

        # Visual e bordas
        corner_radius = 12; # Combinando com o seu Rofi
        frame_width = 2;
        gap_size = 5;
        
        # Espaçamento interno
        padding = 12;
        horizontal_padding = 12;
        text_icon_padding = 15;

        # Formato do texto
        format = "<b>%s</b>\n%b";
        
        # Ícones
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
      };

      # Os blocos de urgência (urgency_low, urgency_normal, urgency_critical)
      # receberão as cores automaticamente pelo catppuccin-nix!
    };
  };

  # --- Configurações de Tema Global (Dark Mode) ---

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # --- Cursor do mouse Catppuccin ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;

    package = pkgs.catppuccin-cursors.frappeMauve;
    name = "catppuccin-frappe-mauve-cursors";
    size = 24;
  };

  # --- Criação das pastas padrão do sistema (documents, downloads, etc) ---
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    templates = null;
    publicShare = null;
    music = null;
  };

  # --- Aplicativos Padrão (MIME Apps) ---
  xdg.mimeApps = {
    enable = true;
    
    # Define os programas padrão para cada tipo de arquivo
    defaultApplications = {
      "application/pdf" = [ "firefox.desktop" ]; # Abrir PDFs no Firefox (como exemplo)
      "image/png"       = [ "org.gnome.eog.desktop" ]; # Abrir PNGs no Eye of GNOME (eog)
      "image/jpeg"      = [ "org.gnome.eog.desktop" ]; # Abrir JPEGs no eog
      "video/mp4"       = [ "mpv.desktop" ];           # Abrir MP4s no MPV
      "text/plain"      = [ "code.desktop" ];          # Abrir textos no VSCode
    };
  };

  # --- Tema GTK Catppuccin ---
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-frappe-mauve-standard";
      package = catppuccinGtk;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # --- Configurações do Firefox ---
  programs.firefox = {
    enable = true;

    profiles."${config.home.username}" = {
      isDefault = true;
      extensions.force = true;
    };
  };

  programs.vscode = {
  enable = true;

  profiles.default.extensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
  ];

  profiles.default.userSettings = {
    "workbench.colorTheme" = "Catppuccin Frappé";
    "window.autoDetectColorScheme" = false;
  };
};

  # --- Hyprland ---
  home.file.".config/hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/hypr/hyprland.lua";

  # --- Hyprlock ---
  home.file.".config/hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
  home.file.".config/hypr/hyprlock-frappe.conf".source = ./hypr/hyprlock-frappe.conf;

  # --- Hyprpaper ---
  home.file.".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;

  # --- Hypridle ---
  home.file.".config/hypr/hypridle.conf".source = ./hypr/hypridle.conf;

  # --- Configurações do Alacritty ---
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.95;
        decorations = "Full";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = 14.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
        };
      };
    };
  };

  # --- Catppuccin ---
  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.flavor = "frappe";

  # Ícones Catppuccin
  catppuccin.gtk.icon = {
    enable = true;
    accent = "mauve";
  };

  # --- Configurações do Waybar ---
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        reload_on_style_change = true;
        passthrough = false;
        reload_style_on_change = true;
        spacing = 10;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        margin-bottom = 1;

        modules-left = [ "custom/icon" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = ["bluetooth" "tray" "pulseaudio" "battery" "clock" ];

        "custom/icon" = {
          format = "";
        };

        "hyprland/window" = {
          separate-outputs = true;
          format = "{class}";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          on-click = "activate";
          format = "{icon}";
        };

        # Configuração do módulo nativo de Bluetooth
        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} conectado(s)";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} conectado(s)\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          
          # Ao clicar com o botão esquerdo, abre o gerenciador visual do blueman
          on-click = "blueman-manager";
        };

        tray = {
          icon-size = 16;
          spacing = 5;
          show-passive-items = true;
        };

        pulseaudio = {
          format = "| {icon} {volume}%";
          format-muted = "| 󰝟 Mutado";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "swayosd-client --output-volume mute-toggle";
          on-click-right = "pavucontrol";
          on-scroll-up = "swayosd-client --output-volume raise";
          on-scroll-down = "swayosd-client --output-volume lower";
        };

        clock = {
          format = "| <span></span>  {:%d/%m/%Y %H:%M}";
          interval = 1;
          tooltip-format = "<tt>{calendar}</tt>";

          calendar = {
            format = {
              today = "<span color='#eed49f'><b>{}</b></span>";
            };
          };

          actions = {
            on-click-right = "shift_down";
            on-click = "shift_up";
          };
        };

        battery = {
          bat = "BAT0";
          interval = 60;

          states = {
            warning = 30;
            critical = 15;
          };

          events = {
            on-discharging-warning =
              "notify-send -u normal 'Low Battery'";
            on-discharging-critical =
              "notify-send -u critical 'Very Low Battery'";
            on-charging-100 =
              "notify-send -u normal 'Battery Full!'";
          };

          format = "| {icon} {capacity}%";
          "format-charging" = "| 󰂄 {capacity}%";
          "format-plugged" = "| 🔌 {icon} {capacity}%";
          "format-full" = "|  100%";

          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];

          max-length = 25;
        };
      };
    };

    # CSS do Waybar
    style = ''
      * {
        font-family: "JetBrains Mono Nerd", monospace;
        border: none;
        min-height: 0;
      }

      window#waybar {
        background-color: alpha(@base, 0.75);
        border-radius: 0;
        color: @sapphire;
        padding: 2px 12px;
        transition: 0.3s all;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        padding: 0 1rem;
        color: @sapphire;
        border: none;
      }

      .modules-center {
        padding: 2px;
      }

      #bluetooth {
          color: #89b4fa;
          padding: 0 10px;
      }

      #bluetooth.disconnected {
          color: #6c7086;
      }

      #bluetooth.connected {
          color: #a6e3a1;
      }

      #custom-icon {
        font-size: 15px;
        padding-right: 5px;
      }

      #window {
        font-weight: bold;
        color: @sky;
        transition: all 0.3s ease;
      }

      #workspaces {
        font-weight: bold;
        font-size: 12px;
        border: none;
      }

      #workspaces button {
        color: @sapphire;
        border-radius: 0;
        transition: 0.2s ease-out;
        border-bottom: 1px solid transparent;
      }

      #workspaces button.urgent {
        border-bottom: 1px solid @blue;
      }

      #workspaces button.active {
        border-bottom: 1px solid @yellow;
        color: @yellow;
      }

      #tray {
        color: @sapphire;
      }

      #clock {
        transition: all 0.3s ease;
        font-weight: bold;
      }

      #clock:hover {
        color: @yellow;
      }
    '';
  };

  # --- Configurações do Rofi (Modo Nativo Nix) ---
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,run,window,filebrowser";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      display-filebrowser = " Files";
      drun-display-format = "{name}";
      font = "JetBrainsMono Nerd Font 12";
      hover-select = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      scroll-method = 0;
      terminal = "alacritty";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        base = mkLiteral "#303446";
        mantle = mkLiteral "#292c3c";
        crust = mkLiteral "#232634";
        surface0 = mkLiteral "#414559";
        surface1 = mkLiteral "#51576d";
        surface2 = mkLiteral "#626880";
        overlay0 = mkLiteral "#737994";
        overlay1 = mkLiteral "#838ba7";

        text = mkLiteral "#c6d0f5";
        subtext0 = mkLiteral "#a5adce";
        subtext1 = mkLiteral "#b5bfe2";

        rosewater = mkLiteral "#f2d5cf";
        flamingo = mkLiteral "#eebebe";
        pink = mkLiteral "#f4b8e4";
        mauve = mkLiteral "#ca9ee6";
        red = mkLiteral "#e78284";
        maroon = mkLiteral "#ea999c";
        peach = mkLiteral "#ef9f76";
        yellow = mkLiteral "#e5c890";
        green = mkLiteral "#a6d189";
        teal = mkLiteral "#81c8be";
        sky = mkLiteral "#99d1db";
        sapphire = mkLiteral "#85c1dc";
        blue = mkLiteral "#8caaee";
        lavender = mkLiteral "#babbf1";

        bg = mkLiteral "@base";
        bg-alt = mkLiteral "@surface0";
        fg = mkLiteral "@text";
        fg-alt = mkLiteral "@subtext0";
        accent = mkLiteral "@mauve";
        urgent = mkLiteral "@red";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      "window" = {
        width = mkLiteral "680px";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px solid";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "12px";
        padding = 0;
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "real";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg";
        border-radius = mkLiteral "12px";
        children = mkLiteral "[ inputbar, message, listview ]";
        spacing = 0;
        padding = 0;
      };

      "inputbar" = {
        background-color = mkLiteral "@mantle";
        border-radius = mkLiteral "12px 12px 0 0";
        padding = mkLiteral "14px 20px";
        spacing = mkLiteral "12px";
        children = mkLiteral "[ prompt, entry ]";
      };

      "prompt" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@crust";
        padding = mkLiteral "6px 12px";
        border-radius = mkLiteral "8px";
        font = "JetBrainsMono Nerd Font Bold 12";
      };

      "entry" = {
        background-color = mkLiteral "@surface0";
        text-color = mkLiteral "@text";
        padding = mkLiteral "6px 12px";
        border-radius = mkLiteral "8px";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@overlay0";
        cursor = mkLiteral "text";
      };

      "message" = {
        background-color = mkLiteral "@bg";
        border = mkLiteral "0 0 1px 0";
        border-color = mkLiteral "@surface0";
        padding = mkLiteral "8px 20px";
      };

      "textbox" = {
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@subtext1";
        padding = mkLiteral "4px";
      };

      "listview" = {
        background-color = mkLiteral "@bg";
        padding = mkLiteral "8px 8px 12px 8px";
        lines = 8;
        columns = 1;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "4px";
        scrollbar = false;
        cycle = true;
        dynamic = true;
        border-radius = mkLiteral "0 0 12px 12px";
      };

      "element" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        padding = mkLiteral "10px 16px";
        spacing = mkLiteral "12px";
        border-radius = mkLiteral "8px";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal, element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      "element normal.urgent, element alternate.urgent" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@urgent";
      };

      "element normal.active, element alternate.active" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
      };

      "element selected.normal, element selected.active" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@crust";
      };

      "element selected.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@crust";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "28px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "bold underline";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      "scrollbar" = {
        width = mkLiteral "4px";
        handle-width = mkLiteral "4px";
        handle-color = mkLiteral "@surface2";
        border-radius = mkLiteral "4px";
        background-color = mkLiteral "@surface0";
      };

      "mode-switcher" = {
        background-color = mkLiteral "@mantle";
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";
      };

      "button" = {
        background-color = mkLiteral "@surface0";
        text-color = mkLiteral "@subtext1";
        padding = mkLiteral "8px 16px";
        border-radius = mkLiteral "8px";
        cursor = mkLiteral "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@crust";
      };
    };
  };
}