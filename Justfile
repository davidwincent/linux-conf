install-nvim:
  #!/usr/bin/env bash
  set -x

  curl -L -o ~/nvim.appimage https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
  appimage_checksum="$(curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage.sha256sum)"

  # Calculate the SHA256 checksum of the downloaded file
  # actual_checksum="$(shasum -a 256 ~/nvim.appimage | awk '{print $1}')"

  # Compare the calculated checksum with the expected checksum
  if ! echo "$appimage_checksum" | sha256sum -c; then
    echo "File is invalid"
    exit 1
  else
    echo "File is valid"
  fi

  mv ~/nvim.appimage ~/bin/nvim
  chmod ug+x ~/bin/nvim

kickstart-nvim:
  #!/usr/bin/env bash
  set -x

  if [ -d "$HOME/.config/nvim" ]; then
    echo "$HOME/.config/nvim already exists"
    exit 1
  fi

  git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"

install-nodejs:
  #!/usr/bin/env bash
  # set -x

  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

  # shellcheck source=/dev/null
  source "$HOME/.nvm/nvm.sh"

  nvm install --lts --default

kill-zombies:
  #!/usr/bin/env bash

  # Get the current shell's process ID
  current_pid=$$

  # Get the user ID of the current user
  current_user=$(id -u)

  # Get a list of all processes started by the current user
  processes=$(ps -u $current_user -o pid=)

  # Kill all processes except the current shell and SSH process
  for pid in $processes; do
    # Skip the current shell's process ID
    if [ $pid -ne $current_pid ]; then
      # Check if the process is the SSH process
      cmd=$(ps -p $pid -o comm=)
      if [[ $cmd != "sshd"* ]]; then
        kill $pid
        echo "killed -> $pid"
      fi
    fi
  done

install-buildkit:
  #!/usr/bin/env bash
  set -x
  
  tag="v0.11.6"
  version="buildkit-v0.11.6.linux-amd64.tar.gz"

  curl -L -o ~/$version https://github.com/moby/buildkit/releases/download/$tag/$version

  tarfile="$HOME/$version"

  sudo tar Cxzvvf /usr/local $tarfile

install-protobuf:
  #!/usr/bin/env bash
  set -x
  
  tag="v23.2"
  version="protoc-23.2-linux-x86_64"

  curl -L -o ~/$version.zip https://github.com/protocolbuffers/protobuf/releases/download/$tag/$version.zip

  zipfile="$HOME/$version.zip"

  unzip $zipfile -d ./$version
  sudo cp -r ./$version/bin/* /usr/local/bin

install-nerdctl:
  #!/usr/bin/env bash
  set -x
  
  tag="v1.4.0"
  version="nerdctl-1.4.0-linux-amd64.tar.gz"

  curl -L -o ~/$version https://github.com/containerd/nerdctl/releases/download/$tag/$version
  nerdctl_checksums="$(curl -L https://github.com/containerd/nerdctl/releases/download/$tag/SHA256SUMS)"
  sha256sum="$(echo "$nerdctl_checksums" | sha256sum -c)"

  if [[ "$sha256sum" != *"$version: OK"* ]]; then
    echo "File is invalid"
    exit 1
  else
    echo "File is valid"
  fi

  tarfile="$HOME/$version"

  sudo tar Cxzvvf /usr/local/bin $tarfile

  containerd-rootless-setuptool.sh install


install-libevent:
  #!/usr/bin/env bash
  set -x
  
  tag="release-2.1.12-stable"
  version="libevent-2.1.12-stable"

  curl -L -o ~/$version.tar.gz https://github.com/libevent/libevent/releases/download/$tag/$version.tar.gz
  curl -L -o ~/$version.tar.gz.asc https://github.com/libevent/libevent/releases/download/$tag/$version.tar.gz.asc

  gpg_verify="$(gpg --keyserver-options auto-key-retrieve --verify ~/$version.tar.gz.asc 2>&1 || exit 0)"

  if [[ "$gpg_verify" != *"new key but contains no user ID - skipped"* ]]; then
    echo "File is invalid"
    exit 1
  else
    echo "File is valid"
  fi
  tarfile="$HOME/$version.tar.gz"

  tar -zxf $tarfile
  cd $version/
  ./configure --prefix=/usr/local --enable-shared
  make && sudo make install

install-ncurses:
  #!/usr/bin/env bash
  set -x
  
  tag="current"
  version="ncurses-6.4-20230107"

  curl -L -o ~/$version.tgz https://invisible-island.net/archives/ncurses/$tag/$version.tgz
  curl -L -o ~/$version.tgz.asc https://invisible-island.net/archives/ncurses/$tag/$version.tgz.asc

  gpg_verify="$(gpg --keyserver-options auto-key-retrieve --verify ~/$version.tgz.asc 2>&1 || exit 0)"

  if [[ "$gpg_verify" != *"new key but contains no user ID - skipped"* ]]; then
    echo "File is invalid"
    exit 1
  else
    echo "File is valid"
  fi
  tarfile="$HOME/$version.tgz"

  tar -zxf $tarfile
  cd $version/
  ./configure --prefix=usr/local --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$HOME/.local/lib/pkgconfig
  make && sudo make install

install-tmux:
  #!/usr/bin/env bash
  sudo apt update
  sudo apt install libevent-dev ncurses-dev build-essential bison pkg-config automake
  set -x

  tag="refs/tags"
  version="3.3a"

  curl -L -o ~/tmux-$version.tar.gz https://github.com/tmux/tmux/archive/$tag/$version.tar.gz

  tarfile="$HOME/tmux-$version.tar.gz"
  tar -zxf $tarfile
  cd tmux-$version/
  sh autogen.sh
  PKG_CONFIG_PATH=usr/local/lib/pkgconfig sh ./configure --prefix=/usr/local
  make && sudo make install

install-sqlite-x86:
  #!/usr/bin/env bash
  set -x

  tag="2023"
  version="sqlite-tools-linux-x86-3420000"
  2023/sqlite-tools-linux-x86-3420000.zip

  curl -L -o ./$version.zip https://www.sqlite.org/$tag/$version.zip

  zipfile="./$version.zip"

  unzip -o $zipfile -d .
  chmod -x $version/*
  find $version -maxdepth 1 -type f -printf '%f\n' | xargs -i bash -c 'sudo cp $HOME/$2/$1 /usr/local/bin/  ; sudo chmod +x /usr/local/bin/$1; echo /usr/local/bin/$1 installed.' - {} $version

upgrade-kernel:
  #!/usr/bin/env bash
  ##
  ## See https://linuxhint.com/upgrade-kernel-in-debian-11-bullseye/
  ##

  set -e
  set -x
  
  branch="v5.x"
  kernel_version="linux-5.15.115"

  wget -N https://cdn.kernel.org/pub/linux/kernel/$branch/$kernel_version.tar.gz
  wget -N https://cdn.kernel.org/pub/linux/kernel/$branch/$kernel_version.tar.sign
  gunzip -f $kernel_version.tar.gz
  # gpg --encrypt --recipient $(id -u) --trust-model always $kernel_version.tar.sign
  gpg_verify="$(gpg --keyserver-options auto-key-retrieve --verify $kernel_version.tar.sign 2>&1 || exit 0)"

  if [[ "$gpg_verify" != *"new key but contains no user ID - skipped"* ]]; then
    echo "File is invalid"
    exit 1
  else
    echo "File is valid"
  fi

  tarfile="$HOME/$kernel_version.tar"
  rm -rf ./$kernel_version
  tar -xvf $tarfile
  cd ./$kernel_version

  sudo cp -v /boot/config-$(uname -r) .config
  sudo apt-get update
  sudo apt-get install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev dwarves -y

  sudo make menuconfig
  sudo make localmodconfig
  sudo make bzImage
  sudo make modules && sudo make modules_install
  sudo make install
  sudo update-grub

  echo "You made it! now reboot."

enable-all-the-watches:
  #!/usr/bin/env bash

  sudo sysctl -w fs.inotify.max_user_watches=100000 
  sudo sysctl -w fs.inotify.max_user_instances=100000

