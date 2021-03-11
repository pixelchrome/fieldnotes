---
linkTitle: "TMUX"
weight: 200
---

# TMUX and XPANES

I am using `xpanes` when I need to connect to more than one host via `ssh`

## xpanes

## Examples

### Connect to three hosts

* `-c` - command executed in each pane
* `-t` - title for each pane
* `-C 3` - arrange panes in **3** columns ( `-R 3` would arrange in **three** rows)

```sh
xpanes -t -C 3 -c "ssh -l harry {}" rke{1..3}
```