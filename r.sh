#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

COUNTER=0

  while [ $COUNTER -lt 5 ]; do

       tmux kill-session -t $THIS_DIR

           tmux new-session -s $THIS_DIR "lua bot.lua"

        tmux detach -s $THIS_DIR

    sleep 1

  done
