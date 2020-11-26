#!/bin/bash

# Usage: e.sh <args>
# <args> are any valid arguments for emacsclient

nohup $(which emacsclient) -a "" -c "$@" &>/dev/null & disown %%
