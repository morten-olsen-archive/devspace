FROM archlinux
ENV TERM=xterm-256color
RUN \
    pacman -Syu --noconfirm \
      base-devel \
      zsh \
      git \
      stow \
      neovim \
      openssh \
      gnupg \
      exa \
      tmux \
      tmate \
      wget \
      unzip \
      github-cli \
      ripgrep \
      codespell \
      ansible \
      docker \
      bat

RUN \
    useradd -m -s /usr/bin/zsh developer && \
    mkdir -p /workspace && \
    chown developer:root /workspace && \
    usermod -a -G docker developer
USER developer
WORKDIR /home/developer
RUN \
    mkdir ~/.cache && \
    mkdir -p ~/work/share.nvim && \
    git clone https://github.com/morten-olsen/share.nvim ~/work/share.nvim && \
    git clone https://github.com/morten-olsen/dotfiles && \
    rm /home/developer/.bashrc && \
    cd dotfiles && \
    git submodule init && \
    git submodule update && \
    ls | xargs stow && \
    cd ~/.config/nvim && \
    git checkout main
RUN \
    source ~/.bashrc && \
    nvm install 16 && \
    npm i -g yarn write-good fx && \
    git clone --depth 20 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim && \
    nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
WORKDIR /workspace
CMD sleep 86400
