
install-oh-my-zsh:
	echo "Installing Oh My Zsh..." && \
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
	echo "Downloading my configuration..." && \
	curl -o ~/.zshrc https://raw.githubusercontent.com/SantiagoPittella/MacOS-configs/main/.zshrc && \
	echo "Complete!"

install-languages:
	echo "Instaling NodeJS, Erlang and Elixir using asdf..." && \
	brew install coreutils curl git && \
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0 && \
	echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc && \
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
	asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git && \
	asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
	echo "Complete!"

additional-tools:
	brew install cloc jq 