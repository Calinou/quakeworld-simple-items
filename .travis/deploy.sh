#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Upload artifacts to GitHub Releases
ls -lh out/*
wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
bash upload.sh out/*
