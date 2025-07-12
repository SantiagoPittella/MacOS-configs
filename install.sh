#!/usr/bin/env bash
set -euo pipefail
export DOTFILES="https://raw.githubusercontent.com/SantiagoPittella/MacOS-configs/main"
export ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

install_brew() {
  if ! command -v brew >/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Initialize brew environment
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "✅ Homebrew already installed."
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

install_oh_my_zsh() {
  echo "🌀 Installing Oh My Zsh..."
  export RUNZSH=no CHSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  curl -fsSL "$DOTFILES/.zshrc" -o "$ZSHRC"
}

install_asdf_langs() {
  echo "🔧 Installing languages and tools via asdf..."
  brew install coreutils curl git
  if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  fi
  grep -q "asdf.sh" "$ZSHRC" || echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> "$ZSHRC"

  for lang in nodejs erlang elixir neovim; do
    asdf plugin-add "$lang" || asdf plugin-update "$lang"
    asdf install "$lang" latest
    asdf global "$lang" latest
  done
  asdf reshim
}

install_additional_tools() {
  echo "🛠 Installing extra CLI tools..."
  brew install cloc jq neovim
}

install_rustup() {
  echo "⚙️ Installing Rust using rustup..."
  if ! command -v rustup >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi
  rustup default stable
}

main() {
  install_brew
  install_oh_my_zsh
  install_asdf_langs
  install_additional_tools
  install_rustup
  brew update && brew upgrade
  echo "🎉 Setup complete!"
}

main "$@"
