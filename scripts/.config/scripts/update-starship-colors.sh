#!/bin/bash
COLORS="$HOME/.config/waybar/colors.css"
TOML="$HOME/.config/starship.toml"
BASELINE="$HOME/.config/starship.baseline.toml"

# Save original baseline once
if [ ! -f "$BASELINE" ]; then
    cp "$TOML" "$BASELINE"
fi

get_color() {
    grep "@define-color $1 " "$COLORS" | sed 's/.*#\([0-9a-fA-F]*\);.*/\1/'
}

C1=$(get_color "background")
C2=$(get_color "surface_container")
C3=$(get_color "surface_variant")
C4=$(get_color "secondary_container")
C5=$(get_color "primary")

[ -z "$C1" ] && C1="2E3440"
[ -z "$C2" ] && C2="3B4252"
[ -z "$C3" ] && C3="434C5E"
[ -z "$C4" ] && C4="4C566A"
[ -z "$C5" ] && C5="5E81AC"

# Always work from baseline so colors don't drift
cp "$BASELINE" "$TOML"

sed -i \
    "s/#2E3440/#${C1}/gI; \
     s/#3B4252/#${C2}/gI; \
     s/#434C5E/#${C3}/gI; \
     s/#4C566A/#${C4}/gI; \
     s/#5E81AC/#${C5}/gI" "$TOML"

echo "Starship updated: $C1 $C2 $C3 $C4 $C5"

# Force redraw in all active terminals by sending SIGWINCH (resize signal)
# This triggers a prompt redraw in zsh
pkill -WINCH zsh
