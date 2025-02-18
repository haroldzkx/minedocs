#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Output colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PLAIN='\033[0m'

# Check for root
check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    printf "${RED}Please use root to run this script (sudo bash bash.sh)${PLAIN}\n" >&2
    return 1
  fi
}

check_user_exists() {
  local user="$1"
  if ! id "$user" &>/dev/null; then
    printf "${RED}User [ %s ] Not Exists ${PLAIN}\n" "$user" >&2
    return 1
  fi
}

install_sudo_if_missing() {
  if ! command -v sudo &>/dev/null; then
    printf "${YELLOW}Not Found [ sudo ]，try to install it...${PLAIN}\n"
    if command -v apt &>/dev/null; then
      apt update && apt install -y sudo
    elif command -v yum &>/dev/null; then
      yum install -y sudo
    elif command -v dnf &>/dev/null; then
      dnf install -y sudo
    else
      printf "${RED}Cann't install sudo automatically, Please install sudo by yourself.${PLAIN}\n" >&2
      return 1
    fi
  fi
}

add_sudo_user() {
  local username="happy"

  if ! check_user_exists "$username"; then
    return 1
  fi

  if grep -Eq "^$username\s+ALL=\(ALL(:ALL)?\)\s+ALL" /etc/sudoers; then
    printf "${GREEN}User %s has exist in sudoers ${PLAIN}\n" "$username"
    return 0
  fi

  chmod +w /etc/sudoers

  if ! printf "%s\tALL=(ALL:ALL) ALL\n" "$username" >> /etc/sudoers; then
    printf "${RED}Add sudo permissions [ FAILED ]. ${PLAIN}\n" >&2
    chmod -w /etc/sudoers
    return 1
  fi

  chmod -w /etc/sudoers
  printf "${GREEN}Add sudo permissions for %s [ SUCCESS ]${PLAIN}\n" "$username"
}

check_user_home() {
  local user="happy"
  local home_dir; home_dir=$(eval echo "~$user")

  if [[ ! -d "$home_dir" ]]; then
    printf "${RED}User %s home directory not exist: %s${PLAIN}\n" "$user" "$home_dir" >&2
    return 1
  fi

  printf "%s\n" "$home_dir"
}

create_bash_aliases() {
  local user="happy"
  local home_dir; home_dir=$(check_user_home) || return 1
  local alias_file="$home_dir/.bash_aliases"

  cat > "$alias_file" << 'EOF'
# python
export pybfsu=https://mirrors.bfsu.edu.cn/pypi/web/simple
export pyustc=https://mirrors.ustc.edu.cn/pypi/simple

# system
alias sb='source /home/happy/.bashrc'

# list directory
alias la='ls -a'
alias ll='ls -l'
alias llh='ls -lh'
alias list='ls -lha'
EOF

  chown "$user":"$user" "$alias_file"
  chmod 644 "$alias_file"
  printf "${GREEN}.bash_aliases has created: %s${PLAIN}\n" "$alias_file"
}

# Backup and replace APT source with Aliyun mirror
add_aliyun_source() {
  local source_file="/etc/apt/sources.list"
  local backup_file="/etc/apt/sources.list.backup"

  if [[ ! -f "$source_file" ]]; then
    printf "${RED}Not Found the file [sources.list]: %s${PLAIN}\n" "$source_file" >&2
    return 1
  fi

  cp "$source_file" "$backup_file"

  if ! sed -i -e 's/^[^#]/#&/' "$source_file"; then
    printf "${RED}Failed to Comment on the original source${PLAIN}\n" >&2
    return 1
  fi

  cat << 'EOF' >> "$source_file"
deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
EOF

  if ! apt update; then
    printf "${RED}Update Software Package Lists [ FAIL ]${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Update Software Package Lists [ SUCCESS ], Add aliyun mirror.${PLAIN}\n"
}

install_vim() {
  if command -v vim &>/dev/null; then
    printf "${YELLOW}Vim has installed, skip this step.${PLAIN}\n"
    return 0
  fi

  if command -v apt &>/dev/null; then
    apt update && apt install -y vim
  elif command -v yum &>/dev/null; then
    yum install -y vim
  elif command -v dnf &>/dev/null; then
    dnf install -y vim
  else
    printf "${RED}Unrecongnized package install manager, can't install vim${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Install Vim [ SUCCESS ]${PLAIN}\n"
}

create_vimrc() {
  local user="happy"
  local home_dir; home_dir=$(eval echo "~$user")

  if [[ ! -d "$home_dir" ]]; then
    printf "${RED}User %s home directory doesn't exist: %s${PLAIN}\n" "$user" "$home_dir" >&2
    return 1
  fi

  local vimrc_file="$home_dir/.vimrc"

  cat > "$vimrc_file" << 'EOF'
set showmatch         " Highlight parentheses

set number            " set line number

set cindent           " C-style indent

set autoindent

set tabstop=4         " set tab width
set softtabstop=4
set shiftwidth=4      " The uniform indentation is 4

syntax on
EOF

  chown "$user":"$user" "$vimrc_file"
  chmod 644 "$vimrc_file"
  printf "${GREEN}.vimrc created SUCCESS: %s${PLAIN}\n" "$vimrc_file"
}

install_tmux() {
  if command -v tmux &>/dev/null; then
    printf "${YELLOW}tmux has installed, skip this step.${PLAIN}\n"
    return 0
  fi

  if command -v apt &>/dev/null; then
    apt update && apt install -y tmux
  elif command -v yum &>/dev/null; then
    yum install -y tmux
  elif command -v dnf &>/dev/null; then
    dnf install -y tmux
  else
    printf "${RED}Unrecongnized package install manager, can't install tmux${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Install tmux [ SUCCESS ]${PLAIN}\n"
}

create_tmux_conf() {
  local user="happy"
  local home_dir; home_dir=$(eval echo "~$user")
  local conf_file="$home_dir/.tmux.conf"

  if [[ ! -d "$home_dir" ]]; then
    printf "${RED}User %s home directory doesn't exist: %s${PLAIN}\n" "$user" "$home_dir" >&2
    return 1
  fi

  cat > "$conf_file" << 'EOF'
# set scroll screen like vim
setw -g mode-keys vi

# session index from 1
set -g base-index 1

# pane index from 1, not 0
set -g pane-base-index 1

# vim style to move cursor in pane
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
EOF

  chown "$user":"$user" "$conf_file"
  chmod 644 "$conf_file"
  printf "${GREEN}.tmux.conf created SUCCESS: %s${PLAIN}\n" "$conf_file"
}

apply_tmux_config() {
  local user="happy"
  local home_dir; home_dir=$(eval echo "~$user")
  local conf_file="$home_dir/.tmux.conf"

  if [[ ! -f "$conf_file" ]]; then
    printf "${RED}Not Found %s Configure file, can't load ${PLAIN}\n" "$conf_file" >&2
    return 1
  fi

  if ! su - "$user" -c "tmux new-session -d -s __config_loader && tmux source-file '$conf_file' && tmux kill-session -t __config_loader"; then
    printf "${RED}Load tmux config [ FAILED ]${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Load tmux config [ SUCCESS ] %s${PLAIN}\n" "$conf_file"
}

install_curl() {
  if command -v curl &>/dev/null; then
    printf "${YELLOW}curl has installed, skip this step.${PLAIN}\n"
    return 0
  fi

  if command -v apt &>/dev/null; then
    apt update && apt install -y curl
  elif command -v yum &>/dev/null; then
    yum install -y curl
  elif command -v dnf &>/dev/null; then
    dnf install -y curl
  else
    printf "${RED}Unrecongnized package install manager, can't install curl${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Install curl [ SUCCESS ]${PLAIN}\n"
}

main() {
  if ! check_root; then
    return 1
  fi

  if ! add_aliyun_source; then
    return 1
  fi

  if ! install_sudo_if_missing; then
    return 1
  fi

  if ! add_sudo_user; then
    return 1
  fi

  if ! create_bash_aliases; then
    return 1
  fi

  if ! install_vim; then
    return 1
  fi

  if ! create_vimrc; then
    return 1
  fi

  if ! install_tmux; then
    return 1
  fi

  if ! create_tmux_conf; then
    return 1
  fi

  if ! apply_tmux_config; then
    return 1
  fi

  if ! install_curl; then
    return 1
  fi
}

main
