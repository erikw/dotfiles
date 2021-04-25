#!/usr/bin/env python3
# Requirements: $ pip3 install iterm2

import sys
#sys.path.append('/usr/local/lib/python3.9/site-packages')
# sys.path.append('/usr/local/Cellar/python@3.9/3.9.4/Frameworks/Python.framework/Versions/3.9/lib/python39.zip')
# sys.path.append('/usr/local/Cellar/python@3.9/3.9.4/Frameworks/Python.framework/Versions/3.9/lib/python3.9')
# sys.path.append('/usr/local/Cellar/python@3.9/3.9.4/Frameworks/Python.framework/Versions/3.9/lib/python3.9/lib-dynload')
# sys.path.append('/usr/local/lib/python3.9/site-packages')
# sys.path.append('/usr/local/Cellar/protobuf/3.15.8/libexec/lib/python3.9/site-packages')
# sys.path.append('/usr/local/Cellar/sip/6.0.3_1/libexec/lib/python3.9/site-packages')


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
