#!/bin/bash

echo '
# CONFIGURATION FILE FOR SETUPCON

# Consult the console-setup(5) manual page.

ACTIVE_CONSOLES="/dev/tty[1-9]"

CHARMAP="UTF-8"

CODESET="guess"
FONTFACE="Fixed"
FONTSIZE="8x16"

VIDEOMODE=

# The following is an example how to use a braille font
# FONT="lat9w-08.psf.gz brl-8x8.psf"
' | sudo tee /etc/default/console-setup
