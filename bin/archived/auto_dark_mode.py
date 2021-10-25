#!/usr/bin/env python3
# Fork of https://gist.github.com/jamesmacfie/2061023e5365e8b6bfbbc20792ac90f8
# that intergates delegates to solarized_toggle.sh
# Script will be installed to ~/Library/Application\ Support/iterm2/Scripts

# NOTE this script was abandoned because it's nicer to not depend on iterm for having monitoring of system appearance mode change. Instead macos_appearance_monitor.sh handles this with a launch agent.

import subprocess
from pathlib import Path
import asyncio
import iterm2

# TODO can't call solarized_iterm2_set.py as this is python3.8 -> sh -> python3.8 but last script needs to be 3.9
	#=> argument to solarized_toggle.sh to not toggle iterm and set it directly here, OR
	# => monitor theme changes globally instead somewhere else.
def solarized_toggle(mode):
    # with open(Path('$XDG_CONFIG_HOME/solarizedtoggle/status').expanduser(), 'w') as status_file:
        # status_file.write(mode)

        cmd = [Path('~/bin/solarized_toggle.sh').expanduser(), mode]
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True,)
        status = proc.wait()
        if status != 0:
            out, err = proc.communicate()
            print(out)
            print(err)

async def main(connection):
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        while True:
            # Block until theme changes
            theme = await mon.async_get()

            # Themes have space-delimited attributes, one of which will be light or dark.
            parts = theme.split(" ")
            mode = ""
            if "dark" in parts:
                solarized_toggle("dark")
            else:
                solarized_toggle("light")

#iterm2.run_forever(main)
