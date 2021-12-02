#!/bin/bash

source ~/.bashrc

# Test tool availability
which node
which yarn
which write-good
which npm
which nvim
which gh
which bat
which exa

# Test environmnet variables
[ "$EDITOR" = "nvim" ]
[ "$TERM" = "xterm-256color" ]
