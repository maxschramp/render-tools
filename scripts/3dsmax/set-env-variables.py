#!.\venv\Scripts\python.exe
# template courtesy of https://adamj.eu/tech/2021/10/09/a-python-script-template-with-and-without-type-hints-and-async/

from __future__ import annotations

import subprocess
import argparse
import os
from collections.abc import Sequence


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    # Add arguments here (https://docs.python.org/3/library/argparse.html)
    # parser.add_argument("--name", type=str, required=True, nargs=1)
    args = parser.parse_args(argv)

    # Start writing code here
    try:
        render_tools_path = "\\".join(os.path.dirname(os.path.realpath(__file__)).split("\\")[0:int(os.path.dirname(os.path.realpath(__file__)).split("\\").index("render-tools"))+1])
        print(f"found render-tools at {render_tools_path}")
        subprocess.call(["setx","ADSK_3DSMAX_ICONS_ADDON_DIR", os.path.join(render_tools_path,"scripts","3dsmax","ADSK_3DSMAX_ICONS_ADDON_DIR")])
        subprocess.call(["setx","ADSK_3DSMAX_MACROS_ADDON_DIR", os.path.join(render_tools_path,"scripts","3dsmax","ADSK_3DSMAX_MACROS_ADDON_DIR")])
        subprocess.call(["setx","ADSK_3DSMAX_PLUGINS_ADDON_DIR", os.path.join(render_tools_path,"scripts","3dsmax","ADSK_3DSMAX_PLUGINS_ADDON_DIR")])
        subprocess.call(["setx","ADSK_3DSMAX_SCRIPTS_ADDON_DIR", os.path.join(render_tools_path,"scripts","3dsmax","ADSK_3DSMAX_SCRIPTS_ADDON_DIR")])
        subprocess.call(["setx","ADSK_3DSMAX_STARTUPSCRIPTS_ADDON_DIR", os.path.join(render_tools_path,"scripts","3dsmax","ADSK_3DSMAX_STARTUPSCRIPTS_ADDON_DIR")])

        map_paths = []
        for dir in os.listdir(os.path.join(render_tools_path, "material-libraries")):
            if os.path.isdir(os.path.join(render_tools_path, "material-libraries",dir)):
                map_paths.append(os.path.join(render_tools_path, "material-libraries",dir))
        print()
        subprocess.call(["setx","ADSK_3DSMAX_ASSETS_MAPS_DIR", ";".join(map_paths)])

        print("set environment variables!")
    except:
        print("unable to set environment variables!")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())