#!/Users/erikw/Library/ApplicationSupport/iTerm2/iterm2env/versions/3.8.6/bin/python3
# For a while it did work to use homebrew's python and do $(pip3 install iterm2), but this broke (on websockets module import).
# What does work is to use the python version installed by Iterm2 > Scripts > Manage.  I will also have the required package iterm2 installed.
# Need to create symlink as there can't be space in shebang path:
# $ ln -s $HOME/Library/Application\ Support Library/ApplicationSupport
# Reference: https://iterm2.com/python-api/tutorial/running.html

import sys
import argparse
import iterm2

def parse_args():
    parser = argparse.ArgumentParser(description="Set Solarized Color Preset in iterm2.")
    parser.add_argument('mode', help='dark or light')

    args = parser.parse_args()
    if args.mode not in ('dark', 'light'):
        print("mode argument must be in ('dark', 'light'). '{:s}' was given".format(args.mode), file=sys.stderr)
        sys.exit(1)
    return args.mode

async def main(connection):
    """Toggle Color Preset to Solarized Dark/Light"""
    mode = parse_args()

    app = await iterm2.async_get_app(connection)
    session=app.current_terminal_window.current_tab.current_session
    profile=await session.async_get_profile()
    preset_name = "Solarized Dark" if mode == "dark" else "Solarized Light"
    preset = await iterm2.ColorPreset.async_get(connection, preset_name)
    await profile.async_set_color_preset(preset)


if __name__ == "__main__":
    iterm2.run_until_complete(main)
