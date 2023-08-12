#!/bin/bash -e
#
# Common utilities for scripts
# Copyright (c) {{ YEAR }} - {{ AUTHOR }} <{{ AUTHOR_EMAIL }}>
#
# Built with shell-script-skeleton v0.0.3 <http://github.com/z017/shell-script-skeleton>

#######################################
# CONSTANTS & VARIABLES
#######################################

# Uncomment these lines if you want to use PROJECT_ROOT variable.
# PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# readonly PROJECT_ROOT

#######################################
# FUNCTIONS
#######################################

# Print out messages to STDERR.
function ech() { echo -e "$@" >&2; }

# Print out error messages to STDERR.
function err() { echo -e "\033[0;31mERROR: $*\033[0m" >&2;  }

# Shows an error if required tools are not installed.
function required {
  local e=0
  for tool in "$@"; do
    type "$tool" >/dev/null 2>&1 || {
      e=1 && err "$tool is required for running this script. Please install $tool and try again."
    }
  done
  [[ 1 -gt $e ]] || exit 2
}

# Parse template file variables in the format "{{ VAR }}" with the "VAR" value.
# parse_template <input file template> <output file> <string of variables>
function parse_template {
  local e=0
  [[ ! -f "$1" ]] && err "$1 is not a valid file." && e=1
  [[ $2 != "${2%/*}" ]] && mkdir -p "${2%/*}"
  [[ -z $3 ]] && err "$3, must be an string of variables to replace" && e=1
  if [[ $e -gt 0 ]]; then
    ech "Usage: parse_template <input file template> <output file> <string of variables>"
    exit 2
  fi
  local args
  for v in $3; do
    args="${args}s~{{ $v }}~${!v}~g;"
  done
  sed "$args" < "$1" > "$2"
}

# Parse all template files ".tpl" in the input_dir and saved them to output_dir
# parse_templates <input_dir> <output_dir> <string of variables>
function parse_templates {
  local e=0
  [[ ! -d $1 ]] && err "$1 is not a valid directory." && e=1
  [[ -z $3 ]] && err "$3, must be an string of variables to replace" && e=1
  if [[ $e -gt 0 ]]; then
    ech "Usage: parse_templates <input_dir> <output_dir> <string of variables>"
    exit 2
  fi
  # parse each file
  for file in "$1"/*.tpl*; do
    local filename=${file##*/}
    local outfile=${filename%.tpl*}${filename##*.tpl}
    parse_template "$file" "$2/$outfile" "$3"
  done
}

# Install composer. Download the istaller, validate it, then install composer
# and move it to be availabile for all users.
function install_composer {
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
    >&2 ech 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
  fi

  echo "Downloaded Composer"
  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php

  chmod +x composer.phar
  mv composer.phar /usr/local/bin/composer

  if [ "$RESULT" -gt 0 ]
  then
    exit $RESULT
  fi

  echo "Moved to /usr/local/bin/"
}
