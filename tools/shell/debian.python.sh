#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

USER_NAME="happy"
HOME_DIR="/home/${USER_NAME}"
UV_VERSION="0.8.12"

extract_uv_python_metadata() {
  local version="$1"
  local output; output=$(uv python install --mirror file:///home "$version" 2>&1 || true)

  local date; date=$(grep -oP 'file `/home/\K[0-9]{8}(?=/cpython-)' <<< "$output")
  local filename; filename=$(grep -oP 'file `/home/.+?/(\Kcpython-[^`]+)' <<< "$output")

  if [[ -z "$date" || -z "$filename" ]]; then
    return 1
  fi

  printf "%s|%s|%s\n" "$version" "$date" "$filename"
}

get_cpython_versions() {
  local min_minor="$1"
  local max_minor="$2"

  local versions_raw; versions_raw=$(uv python list 2>/dev/null | grep '^cpython-[0-9]' || true)
  if [[ -z "$versions_raw" ]]; then
    return 1
  fi

  local version_lines; version_lines=$(awk '{print $1}' <<< "$versions_raw")

  awk -v min="$min_minor" -v max="$max_minor" -F'-' '
    /^[^+]+$/ {
      ver = $2
      split(ver, parts, ".")
      major = parts[1]
      minor = parts[2]
      patch = parts[3]

      if ((major == 3) && (minor >= min) && (minor <= max)) {
        key = major "." minor
        if (!(key in latest) || compare(ver, latest[key]) > 0) {
          latest[key] = ver
        }
      }
    }
    function compare(v1, v2,  a, b, i) {
      split(v1, a, ".")
      split(v2, b, ".")
      for (i = 1; i <= 3; i++) {
        if (a[i]+0 > b[i]+0) return 1
        if (a[i]+0 < b[i]+0) return -1
      }
      return 0
    }
    END {
      for (k in latest) {
        print latest[k]
      }
    }
  ' <<< "$version_lines" | sort -Vu
}

download_and_install_python() {
  local version="$1"
  local date="$2"
  local filename="$3"
  local target_dir="${HOME_DIR}/${date}"
  local download_url="https://github.com/astral-sh/python-build-standalone/releases/download/${date}/${filename}"
  local mirror_path="file://${HOME_DIR}"

  mkdir -p "$target_dir"

  if ! wget -O "${target_dir}/${filename}" "$download_url"; then
    printf "Failed to download %s\n" "$download_url" >&2
    return 1
  fi

  if ! su - "${USER_NAME}" -c "uv python install --mirror ${mirror_path} ${version}"; then
    printf "Failed to install Python %s from mirror\n" "$version" >&2
    return 1
  fi

  printf "Python %s installed successfully from %s\n" "$version" "$filename"
}

install_all_versions() {
  # set python version from 3.8 to 3.12
  local min_minor=8
  local max_minor=12

  local versions; versions=$(get_cpython_versions "$min_minor" "$max_minor")
  local version line

  while IFS= read -r version; do
    if ! line=$(extract_uv_python_metadata "$version"); then
      continue
    fi

    IFS='|' read -r ver date filename <<< "$line"
    download_and_install_python "$ver" "$date" "$filename" || continue
  done <<< "$versions"
}

install_uv_offline() {
  local uv_archive="uv-x86_64-unknown-linux-gnu.tar.gz"
  local uv_url="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${uv_archive}"
  local install_dir="/usr/local"
  local binary_name="uv-x86_64-unknown-linux-gnu"
  local target_dir="${install_dir}/uv"
  local bashrc_file="${HOME_DIR}/.bashrc"

  cd ${HOME_DIR}

  if ! wget -O "$uv_archive" "$uv_url"; then
    printf "Failed to download UV archive: %s\n" "$uv_url" >&2
    return 1
  fi

  tar -xzf "${HOME_DIR}/$uv_archive" -C "$install_dir"
  mv "${install_dir}/${binary_name}" "$target_dir"

  if [[ ! -x "${target_dir}/uv" ]]; then
    printf "UV binary not found or not executable at: %s\n" "${target_dir}/uv" >&2
    return 1
  fi

  printf 'export PATH="/usr/local/uv:$PATH"\n' >> "$bashrc_file"
  printf 'export PATH="%s/.local/bin:$PATH"\n' "$HOME_DIR" >> "$bashrc_file"

  chown "$USER_NAME:$USER_NAME" "$bashrc_file"

  su - "$USER_NAME" -c "source ${HOME_DIR}/.bashrc"

  if ! su - "$USER_NAME" -c "command -v uv &>/dev/null"; then
    printf "UV not found in PATH after installation\n" >&2
    return 1
  fi

  printf "UV %s installed successfully at %s\n" "$UV_VERSION" "$target_dir"
}

main() {
  install_uv_offline
  install_all_versions
}

main