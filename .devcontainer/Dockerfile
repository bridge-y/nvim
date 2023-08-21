# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT=ubuntu-22.04
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ARG NEOVIM_VERSION
ARG LAZYGIT_VERSION
ARG DELTA_VERSION

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  # For building neovim
  ninja-build \
  gettext \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip \
  curl \
  doxygen \
  lua5.3 \
  # mason.nvim may require
  nodejs \
  npm \
  python3 \
  python3-pip \
  # utility
  ripgrep \
  fish \
  # gh
  && type -p curl >/dev/null || (apt update && apt install curl -y) \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt update \
  && apt install gh -y \
  # Lazygit
  && mkdir -p /tmp/lazygit \
  && cd /tmp/lazygit \
  && curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz | tar xz \
  && install lazygit /usr/local/bin \
  # Commitizen
  && npm install -g commitizen \
  && npm install -g cz-conventional-changelog \
  # Neovim
  && mkdir -p /tmp/ \
  && cd /tmp \
  && git clone https://github.com/neovim/neovim \
  && cd /tmp/neovim \
  && git checkout ${NEOVIM_VERSION} \
  && make -j4 \
  && make install \
  # delta
  && mkdir -p /tmp/delta \
  && cd /tmp/delta \
  && curl -fsSL https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xz --strip-components 1 \
  && mv /tmp/delta/delta /usr/local/bin/ \
  # cleanup
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*
