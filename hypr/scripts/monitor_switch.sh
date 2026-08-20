#!/usr/bin/env bash

# Define as opções do menu
options="1. Estender Tela\n2. Duplicar (Mirror)\n3. Somente Tela Secundária\n4. Somente Tela do Notebook"

# Abre o rofi e captura a escolha
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Projetar Tela:")

# Função para verificar se o monitor externo está fisicamente conectado
is_hdmi_connected() {
    # 'hyprctl monitors all' lista tudo que está plugado. 
    # O grep procura pelo HDMI-A-1 de forma silenciosa (-q)
    if hyprctl monitors all | grep -q "Monitor HDMI-A-1"; then
        return 0 # Conectado
    else
        return 1 # Desconectado
    fi
}

case "$chosen" in
    "1. Estender Tela")
        if is_hdmi_connected; then
            hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
            hyprctl keyword monitor "HDMI-A-1, preferred, auto-left, 1"
            notify-send -u normal -a "Hyprland" "Monitores" "Modo: Estender Tela"
        else
            notify-send -u critical -a "Hyprland" "Monitores" "Erro: Cabo HDMI não está conectado!"
        fi
        ;;
    "2. Duplicar (Mirror)")
        if is_hdmi_connected; then
            hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
            hyprctl keyword monitor "HDMI-A-1, preferred, auto, 1, mirror, eDP-1"
            notify-send -u normal -a "Hyprland" "Monitores" "Modo: Duplicar (Mirror)"
        else
            notify-send -u critical -a "Hyprland" "Monitores" "Erro: Cabo HDMI não está conectado!"
        fi
        ;;
    "3. Somente Tela Secundária")
        if is_hdmi_connected; then
            hyprctl keyword monitor "eDP-1, disable"
            hyprctl keyword monitor "HDMI-A-1, preferred, auto, 1"
            notify-send -u normal -a "Hyprland" "Monitores" "Modo: Somente Tela Secundária"
        else
            # Ação bloqueada! Protege o usuário da tela preta.
            notify-send -u critical -a "Hyprland" "Ação Cancelada" "Nenhum HDMI detectado. Mantendo tela do notebook ativa."
        fi
        ;;
    "4. Somente Tela do Notebook")
        # Esta opção é sempre segura de rodar
        hyprctl keyword monitor "HDMI-A-1, disable"
        hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
        notify-send -u normal -a "Hyprland" "Monitores" "Modo: Somente Tela do Notebook"
        ;;
esac