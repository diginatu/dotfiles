#!/usr/bin/env bash

# This script set up "hybrid.vim" color scheme for gnome-terminal using Gogh
# Gogh       https://github.com/Mayccoll/Gogh
# hybrid.vim https://github.com/w0ng/vim-hybrid

# ====================CONFIG THIS =============================== #
COLOR_01="#282A2E"           # HOST
COLOR_02="#A54242"           # SYNTAX_STRING
COLOR_03="#8C9440"           # COMMAND
COLOR_04="#DE935F"           # COMMAND_COLOR2
COLOR_05="#5F819D"           # PATH
COLOR_06="#85678F"           # SYNTAX_VAR
COLOR_07="#5E8D87"           # PROMP
COLOR_08="#707880"           #

COLOR_09="#373B41"           #
COLOR_10="#CC6666"           # COMMAND_ERROR
COLOR_11="#B5BD68"           # EXEC
COLOR_12="#F0C674"           #
COLOR_13="#81A2BE"           # FOLDER
COLOR_14="#B294BB"           #
COLOR_15="#8ABEB7"           #
COLOR_16="#C5C8C6"           #

BACKGROUND_COLOR="#1D1F21"   # Background Color
FOREGROUND_COLOR="#C5C8C6"   # Text
CURSOR_COLOR="$FOREGROUND_COLOR" # Cursor
PROFILE_NAME="Hybrid Vim"
# =============================================







# =============================================================== #
# | Apply Colors
# ===============================================================|#
function gogh_colors () {
    echo ""
    echo -e "\e[0;30m█████\\e[0m\e[0;31m█████\\e[0m\e[0;32m█████\\e[0m\e[0;33m█████\\e[0m\e[0;34m█████\\e[0m\e[0;35m█████\\e[0m\e[0;36m█████\\e[0m\e[0;37m█████\\e[0m"
    echo -e "\e[0m\e[1;30m█████\\e[0m\e[1;31m█████\\e[0m\e[1;32m█████\\e[0m\e[1;33m█████\\e[0m\e[1;34m█████\\e[0m\e[1;35m█████\\e[0m\e[1;36m█████\\e[0m\e[1;37m█████\\e[0m"
    echo ""
}

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_PATH="$(dirname "$SCRIPT_PATH")"

if [ -e $PARENT_PATH"/apply-colors.sh" ]
then
gogh_colors
source $PARENT_PATH"/apply-colors.sh"

else
gogh_colors
source <(wget  -O - https://raw.githubusercontent.com/Mayccoll/Gogh/master/apply-colors.sh)
fi
