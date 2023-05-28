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

  mv ~/nvim.appimage ~/bin/
  chmod ug+x ~/bin/nvim.appimage

kickstart-nvim:
  #!/usr/bin/env bash
  set -x

  if [ -d "$HOME/.config/nvim" ]; then
    echo "$HOME/.config/nvim already exists"
    exit 1
  fi

  git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"
