#!/bin/bash

error() { printf "✖ %s\n" "$@"
}
warn() { printf "➜ %s\n" "$@"
}

type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

export -f error
export -f warn
export -f type_exists