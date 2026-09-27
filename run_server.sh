#!/usr/bin/env bash
set -u

if [ "${REDNOTE_BACKUP_ON_PREVIEW:-1}" = "1" ]; then
  bash backup_rednote_sheet.sh
fi

bundle _2.2.19_ exec jekyll serve --host 127.0.0.1 --port 4000
