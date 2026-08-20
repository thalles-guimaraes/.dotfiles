#!/usr/bin/env bash

set -u

LAPTOP_MONITOR="eDP-1"
EXTERNAL_MONITOR="HDMI-A-1"

notify() {
    local urgency="$1"
    local title="$2"
    local message="$3"

    notify-send \
        -u "$urgency" \
        -a "Hyprland" \
        "$title" \
        "$message"
}

is_monitor_connected() {
    local monitor="$1"

    hyprctl monitors all | grep -q "Monitor ${monitor}"
}

enable_laptop() {
    hyprctl eval "hl.monitor({
        output = \"${LAPTOP_MONITOR}\",
        mode = \"preferred\",
        position = \"0x0\",
        scale = 1,
    })"
}

enable_external_auto() {
    hyprctl eval "hl.monitor({
        output = \"${EXTERNAL_MONITOR}\",
        mode = \"preferred\",
        position = \"auto\",
        scale = 1,
    })"
}

enable_external_left() {
    hyprctl eval "hl.monitor({
        output = \"${EXTERNAL_MONITOR}\",
        mode = \"preferred\",
        position = \"auto-left\",
        scale = 1,
    })"
}

disable_laptop() {
    hyprctl eval "hl.monitor({
        output = \"${LAPTOP_MONITOR}\",
        disabled = true,
    })"
}

disable_external() {
    hyprctl eval "hl.monitor({
        output = \"${EXTERNAL_MONITOR}\",
        disabled = true,
    })"
}

mirror_external_to_laptop() {
    hyprctl eval "hl.monitor({
        output = \"${EXTERNAL_MONITOR}\",
        mode = \"preferred\",
        position = \"0x0\",
        scale = 1,
        mirror = \"${LAPTOP_MONITOR}\",
    })"
}

options="1. Estender Tela
2. Duplicar (Mirror)
3. Somente Tela Secundária
4. Somente Tela do Notebook"

chosen=$(
    printf '%s\n' "$options" |
        rofi -dmenu -i -p "Projetar Tela:"
)

# Usuário fechou o Rofi sem selecionar nada.
[[ -z "${chosen:-}" ]] && exit 0

case "$chosen" in

    "1. Estender Tela")
        if is_monitor_connected "$EXTERNAL_MONITOR"; then
            enable_laptop
            enable_external_left

            notify \
                normal \
                "Monitores" \
                "Modo: Estender Tela"
        else
            notify \
                critical \
                "Monitores" \
                "Cabo HDMI não está conectado."
        fi
        ;;

    "2. Duplicar (Mirror)")
        if is_monitor_connected "$EXTERNAL_MONITOR"; then
            # A tela do notebook precisa estar ativa para servir
            # como origem do espelhamento.
            enable_laptop
            mirror_external_to_laptop

            notify \
                normal \
                "Monitores" \
                "Modo: Duplicar (Mirror)"
        else
            notify \
                critical \
                "Monitores" \
                "Cabo HDMI não está conectado."
        fi
        ;;

    "3. Somente Tela Secundária")
        if is_monitor_connected "$EXTERNAL_MONITOR"; then
            # Primeiro habilitamos a tela externa.
            # Só depois desligamos a tela interna.
            # Isso reduz o risco de ficar sem nenhuma tela ativa.
            enable_external_auto

            sleep 0.5

            disable_laptop

            notify \
                normal \
                "Monitores" \
                "Modo: Somente Tela Secundária"
        else
            notify \
                critical \
                "Ação Cancelada" \
                "Nenhum HDMI detectado. Mantendo a tela do notebook ativa."
        fi
        ;;

    "4. Somente Tela do Notebook")
        # Primeiro garantimos que a tela interna esteja ativa.
        # Depois desligamos a externa.
        enable_laptop

        sleep 0.5

        disable_external

        notify \
            normal \
            "Monitores" \
            "Modo: Somente Tela do Notebook"
        ;;

esac