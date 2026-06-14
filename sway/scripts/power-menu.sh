#!/bin/sh
# Menú de energía para Sway.
#
# La opción "Cambiar usuario" se mantiene separada de "Cerrar sesión": no debe
# cerrar Sway ni matar la sesión actual. La variante conservadora bloquea la
# sesión actual y delega en systemd-logind la exposición del bloqueo al display
# manager:
#
#   swaylock
#   loginctl lock-session
#
# Si tu display manager soporta cambio de usuario, puedes sustituir la acción de
# switch_user() por su herramienta específica, por ejemplo:
#   - GDM:  gdmflexiserver
#   - SDDM: dm-tool switch-to-greeter

set -eu

prompt="Energía"

lock() {
    swaylock
}

switch_user() {
    swaylock &
    loginctl lock-session
}

logout() {
    swaymsg exit
}

selected="$(printf '%s\n' \
    '󰈄 Cambiar usuario' \
    '󰌾 Bloquear' \
    '󰍃 Cerrar sesión' \
    '󰤄 Suspender' \
    '󰜉 Reiniciar' \
    '󰐥 Apagar' \
    | wofi --dmenu --prompt "$prompt")"

case "$selected" in
    '󰈄 Cambiar usuario')
        switch_user
        ;;
    '󰌾 Bloquear')
        lock
        ;;
    '󰍃 Cerrar sesión')
        logout
        ;;
    '󰤄 Suspender')
        systemctl suspend
        ;;
    '󰜉 Reiniciar')
        systemctl reboot
        ;;
    '󰐥 Apagar')
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
