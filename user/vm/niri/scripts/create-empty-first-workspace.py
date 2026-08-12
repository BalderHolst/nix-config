import niripy
import subprocess
import time

def niri(action, *args):
    subprocess.run(["niri", "msg", "action", action, *map(str, args)])

inst = niripy.Instance()

ws = inst.get_workspaces()

last_w = None
for w in ws:
    if last_w == None: last_w = w
    if w.idx > last_w.idx:
        last_w = w

niri("focus-workspace", last_w.idx)
time.sleep(1.0) # Wait for animation
inst.action("move-workspace-to-index", index=1)
