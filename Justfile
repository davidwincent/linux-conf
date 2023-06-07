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

