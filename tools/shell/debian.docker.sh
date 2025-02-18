#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PLAIN='\033[0m'

check_root() {
  if [[ "$EUID" -ne 0 ]]; then
    printf "${RED}Please run this script as root (sudo bash install_docker.sh)${PLAIN}\n" >&2
    return 1
  fi
}

update_system() {
  apt update
  apt upgrade -y
  apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
  printf "${GREEN}System packages updated and dependencies installed${PLAIN}\n"
}

add_docker_gpg_key() {
  local keyring="/usr/share/keyrings/docker-archive-keyring.gpg"

  if ! curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | gpg --dearmor -o "$keyring"; then
    printf "${RED}Failed to download Docker GPG key${PLAIN}\n" >&2
    return 1
  fi

  chmod 644 "$keyring"
  printf "${GREEN}Docker GPG key added: %s${PLAIN}\n" "$keyring"
}

add_docker_repo() {
  local distro; distro=$(lsb_release -cs)
  local source_file="/etc/apt/sources.list.d/docker.list"
  local entry="deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian ${distro} stable"

  echo "$entry" > "$source_file"
  chmod 644 "$source_file"

  apt update
  printf "${GREEN}Docker repository added and package list updated${PLAIN}\n"
}

install_docker() {
  apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  printf "${GREEN}Docker installation completed${PLAIN}\n"
}

enable_and_start_docker() {
  systemctl enable docker
  systemctl start docker
  printf "${GREEN}Docker started and enabled on boot${PLAIN}\n"
}

verify_docker() {
  if ! docker --version &>/dev/null; then
    printf "${RED}Docker installation verification failed${PLAIN}\n" >&2
    return 1
  fi

  docker --version
}

# add_user_to_docker_group() {
#   local user="happy"

#   if ! id "$user" &>/dev/null; then
#     printf "${RED}User %s does not exist, cannot add to docker group${PLAIN}\n" "$user" >&2
#     return 1
#   fi

#   usermod -aG docker "$user"
#   printf "${YELLOW}User %s added to docker group. Please log out and log back in to apply changes.${PLAIN}\n" "$user"
# }

add_user_to_docker_group() {
  local user="happy"
  local group_file="/etc/group"

  if ! id "$user" &>/dev/null; then
    printf "${RED}User %s does not exist, cannot add to docker group${PLAIN}\n" "$user" >&2
    return 1
  fi

  if ! getent group docker &>/dev/null; then
    if ! groupadd docker; then
      printf "${RED}Failed to create docker group${PLAIN}\n" >&2
      return 1
    fi
  fi

  if ! sudo usermod -aG docker "$user"; then
    printf "${RED}Failed to add user %s to docker group${PLAIN}\n" "$user" >&2
    return 1
  fi

  local socket="/var/run/docker.sock"
  if [[ -S "$socket" ]]; then
    if ! chgrp docker "$socket"; then
      printf "${RED}Failed to set docker.sock group to docker${PLAIN}\n" >&2
      return 1
    fi

    if ! chmod 660 "$socket"; then
      printf "${RED}Failed to set permissions on docker.sock${PLAIN}\n" >&2
      return 1
    fi
  fi

  local pam_file="/etc/pam.d/su"
  if ! grep -q "^auth.*required.*pam_wheel.so" "$pam_file"; then
    printf "${YELLOW}Warning: pam_wheel not configured, this may affect group membership recognition${PLAIN}\n" >&2
  fi

  if ! su - "$user" -c "newgrp docker <<<'docker info' &>/dev/null"; then
    printf "${RED}Failed to apply new group in subshell. Docker command may still require sudo for user %s${PLAIN}\n" "$user" >&2
    return 1
  fi

  printf "${GREEN}User %s added to docker group and group permissions applied immediately${PLAIN}\n" "$user"
}

append_docker_aliases() {
  local user="happy"
  local home_dir; home_dir=$(eval echo "~$user")
  local alias_file="$home_dir/.bash_aliases"

  if [[ ! -f "$alias_file" ]]; then
    touch "$alias_file"
    chown "$user":"$user" "$alias_file"
    chmod 644 "$alias_file"
  fi

  cat >> "$alias_file" << 'EOF'

# docker
alias d='docker'
alias di='docker images'
alias dil='docker images | sed "s|registry.cn-shenzhen.aliyuncs.com/haroldfinch|\$ali|g"'
alias drm='docker rm'
alias drmi='docker rmi'
alias drmf='docker rm -f'
alias dps='docker ps'
alias dpsa='docker ps -a'

export ali=registry.cn-shenzhen.aliyuncs.com/haroldfinch

alias dif='docker images --format "\nRepository: {{.Repository}}\nTag: {{.Tag}}\nImage ID: {{.ID}}\nCreated: {{.CreatedAt}}\nSize: {{.Size}}" | sed "s|registry.cn-shenzhen.aliyuncs.com/haroldfinch|\$ali|g"'

alias dpsal='docker ps -a --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.CreatedAt}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
alias dpsl='docker ps --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.CreatedAt}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
EOF

  chown "$user":"$user" "$alias_file"

  if ! su - "$user" -c "source /home/happy/.bashrc"; then
    printf "${RED}Failed to execute source ~/.bashrc, it may not take effect. Please run manually.${PLAIN}\n" >&2
    return 1
  fi

  printf "${GREEN}Docker aliases appended and loaded successfully${PLAIN}\n"
}

main() {
  if ! check_root; then
    return 1
  fi

  if ! update_system; then
    return 1
  fi

  if ! add_docker_gpg_key; then
    return 1
  fi

  if ! add_docker_repo; then
    return 1
  fi

  if ! install_docker; then
    return 1
  fi

  if ! enable_and_start_docker; then
    return 1
  fi

  if ! verify_docker; then
    return 1
  fi

  if ! add_user_to_docker_group; then
    return 1
  fi

  if ! append_docker_aliases; then
    return 1
  fi
}

main
