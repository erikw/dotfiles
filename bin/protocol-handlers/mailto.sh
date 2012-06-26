#!/bin/bash
# To be used with firefox's mailto:-links.
# Use the following settings in about:config.
#network.protocol-handler.app.mailto;/home/erikw/bin/protocol-handlers/mailto.sh
#network.protocol-handler.expose.mailto;false
#network.protocol-handler.external.mailto;true
#xterm -e mutt -e "source ~/.mutt/colors/mutt-colors-solarized/mutt-colors-solarized-light-16.muttrc" -e "set editor = \"vim --cmd 'let mutt_mode=1' -c 'set background=light'\"" $1
xterm -e mutt -e "source ~/.mutt/colors/mutt-colors-solarized/mutt-colors-solarized-light-16.muttrc" -e "set editor = \"vim --cmd 'let mutt_mode=1'\"" $1
