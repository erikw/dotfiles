#/usr/bin/env sh
# Programs that should be started with each Inglewood KDE session.

# Start Yakuake and load my tmux session.
/usr/bin/env yakuake
yakuake_sessionID=$(qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.activeSessionId)
qdbus org.kde.yakuake /yakuake/tabs setTabTitle $yakuake_sessionID "irctor"
qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal $yakuake_sessionID "irctor attach"

# Start my browser, takes a while to load.
/usr/bin/env firefox &

# Notify MPD song changes.
/usr/bin/env mpdknotifier &

exit 0
