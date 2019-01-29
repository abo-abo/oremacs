#!/usr/bin/env python3
import subprocess
wnd_id = subprocess.check_output(["xdotool", "search", "--name", "emacs"]).decode().split("\n")[-2]
subprocess.call(["wmctrl", "-ia", wnd_id])
subprocess.call(["emacsclient", "--eval", "(counsel-wmctrl)"])
