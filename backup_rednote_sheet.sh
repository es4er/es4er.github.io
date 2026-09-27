#!/usr/bin/env bash
set -u

sheet_csv_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQUX3jbmcxIjz_VyFAy33PJzbYPVKPVXIEOSMdoy7bqRPOl-y1n-lZe8pkZ55WYwkQaqGEAQ0D_idrc/pub?output=csv"
backup_dir="${REDNOTE_BACKUP_DIR:-backup}"
backup_proxy="${REDNOTE_BACKUP_PROXY:-}"
proxy_candidates="${REDNOTE_BACKUP_PROXY_CANDIDATES:-7897 7890 7899 1080 1087 8080 8118 6152 20170}"
timestamp="$(date '+%Y%m%d-%H%M%S')"
dated_file="${backup_dir}/rednote-followers-${timestamp}.csv"
latest_file="${backup_dir}/rednote-followers-latest.csv"
tmp_file="${dated_file}.tmp"

mkdir -p "$backup_dir"

if ! command -v curl >/dev/null 2>&1; then
  echo "Rednote backup skipped: curl is not available."
  exit 0
fi

detect_local_proxy() {
  if [ -n "$backup_proxy" ]; then
    return
  fi

  if ! command -v nc >/dev/null 2>&1; then
    return
  fi

  for port in $proxy_candidates; do
    if nc -z 127.0.0.1 "$port" >/dev/null 2>&1; then
      backup_proxy="http://127.0.0.1:${port}"
      echo "Using detected local proxy ${backup_proxy}"
      return
    fi
  done
}

detect_local_proxy

curl_args=(
  --location
  --fail
  --silent
  --show-error
  --connect-timeout
  8
  --max-time
  20
)

if [ -n "$backup_proxy" ] && [ "$backup_proxy" != "direct" ]; then
  curl_args+=(--proxy "$backup_proxy")
fi

if curl "${curl_args[@]}" "$sheet_csv_url" --output "$tmp_file"; then
  if [ -s "$tmp_file" ]; then
    mv "$tmp_file" "$dated_file"
    cp "$dated_file" "$latest_file"
    echo "Rednote Google Sheet backed up to ${dated_file}"
  else
    rm -f "$tmp_file"
    echo "Rednote backup skipped: downloaded file is empty."
  fi
else
  rm -f "$tmp_file"
  echo "Rednote backup skipped: could not download Google Sheet CSV."
  echo "If your browser uses a proxy, run with REDNOTE_BACKUP_PROXY, for example:"
  echo "REDNOTE_BACKUP_PROXY=http://127.0.0.1:7897 bash backup_rednote_sheet.sh"
fi
