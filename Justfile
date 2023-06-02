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

kill-zombies:
  #!/usr/bin/env bash
  set -x

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
      fi
    fi
  done

