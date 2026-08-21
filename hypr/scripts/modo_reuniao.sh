#!/usr/bin/env bash

set -u

LOCK_FILE="/tmp/modo_reuniao_lock"

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

stop_hypridle() {
    if pgrep -x hypridle >/dev/null; then
        pkill -x hypridle
    fi
}

start_hypridle() {
    if ! pgrep -x hypridle >/dev/null; then
        hypridle >/dev/null 2>&1 &
    fi
}

if [[ -f "$LOCK_FILE" ]]; then
    # Desativa o modo reunião
    rm -f "$LOCK_FILE"

    start_hypridle

    notify \
        normal \
        "Modo Reunião" \
        "Desativado: a tela voltará a bloquear."
else
    # Ativa o modo reunião
    touch "$LOCK_FILE"

    stop_hypridle

    notify \
        critical \
        "Modo Reunião" \
        "Ativado: a tela não vai mais bloquear."
fi