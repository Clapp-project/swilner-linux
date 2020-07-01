#!/usr/bin/env bash

script_path="$(readlink -f ${0%/*})"

cd "${script_path}"
echo 'start cleaning....'
sudo make clean
sudo rm -f "${script_path}/system/mkalteriso"

cd - > /dev/null
echo 'CLEAN DONE'