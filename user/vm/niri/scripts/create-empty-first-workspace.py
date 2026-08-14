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

inst.action("do-screen-transition", delay_ms=0)
niri("focus-workspace", last_w.idx)
inst.action("move-workspace-to-index", index=1)
