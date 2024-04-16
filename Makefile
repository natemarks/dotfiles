.DEFAULT_GOAL := help
.PHONY: gitconfig vim powerline neovim bin
DEFAULT_BRANCH := main
SHELL := /bin/bash
PRJ := $(PWD)
COMMIT := $(shell git rev-parse HEAD)
BIN = $(HOME)/bin
BASHRCD = $(HOME)/bashrc.d
POWERLINE = $(HOME)/.config/powerline
# OS = 'Darwin' or 'Linux'
OS = $(shell uname -s)
# get epoch seconds at the start of the make run
EPOCH = $(shell date +%s)
MKDIR = mkdir -p
LN = ln -vs
LNF = ln -vsf


help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

nodejs: ## Install NodeJS
	curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -;
	sudo apt -y install nodejs

spotify: ## Install spotify repo and package
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - ;
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list;
	sudo apt-get update && sudo apt-get install -y spotify-client

aws_cdk: nodejs ## Install AWS CDK
	sudo npm install -g aws-cdk

pyenv: ## install pyenv
	-git clone https://github.com/pyenv/pyenv.git ~/.pyenv

awscli_v2: ## download and install awscliv2
	-bash scripts/install_awscli_v2.sh
	$(MKDIR) $(HOME)/.aws
	$(LN) $(PRJ)/awscli/config  $(HOME)/.aws/config

docker: ## install docker
	bash scripts/install_docker.sh

packer: ## install docker
	bash scripts/install_packer.sh

slack: ## install slack

bin: ## create and configure $HOME/bin
	$(MKDIR) $(HOME)/bin
	-rm -f $(HOME)/bin/encrypt
	$(LN) $(PRJ)/bin/encrypt $(HOME)/bin/encrypt
	-rm -f $(HOME)/bin/decrypt
	$(LN) $(PRJ)/bin/decrypt $(HOME)/bin/decrypt
	-rm -f $(HOME)/bin/search_zsh_history
	$(LN) $(PRJ)/bin/search_zsh_history $(HOME)/bin/search_zsh_history
	-rm -f $(HOME)/bin/symm_encrypt
	$(LN) $(PRJ)/bin/symm_encrypt.sh $(HOME)/bin/symm_encrypt
	-rm -f $(HOME)/bin/symm_decrypt
	$(LN) $(PRJ)/bin/symm_decrypt.sh $(HOME)/bin/symm_decrypt
	-rm -f $(HOME)/bin/aws_instance_id_from_private_ip.sh
	$(LN) $(PRJ)/bin/aws_instance_id_from_private_ip.sh $(HOME)/bin/aws_instance_id_from_private_ip.sh
	-rm -f $(HOME)/bin/up-tmux.sh
	$(LN) $(PRJ)/bin/up-tmux.sh $(HOME)/bin/up-tmux.sh

$(HOME)/tmp: ## make sure $HOME/tmp
	$(MKDIR) $(HOME)/tmp

$(HOME)/projects: ## make sure $HOME/tmp
	$(MKDIR) $(HOME)/projects

home: bin $(HOME)/tmp $(HOME)/projects ## configure home directory

powerline: ## install and configure powerline
	pip3 install --user powerline-status
	pip3 install --user powerline-gitstatus
	$(MKDIR) $(POWERLINE)/colorschemes
	$(MKDIR) $(POWERLINE)/themes/shell
	$(LN) $(PRJ)/powerline/colorschemes_default.json  $(POWERLINE)/colorschemes/default.json
	$(LN) $(PRJ)/powerline/themes_shell_default.json  $(POWERLINE)/themes/shell/default.json

bash: ## configure bash environment
	$(MKDIR) $(BASHRCD)
	# some desc
	$(LN) $(PRJ)/bashrc.d/add_home_bin_to_path.sh  $(BASHRCD)/add_home_bin_to_path.sh
	$(LN) $(PRJ)/bashrc.d/aliases.sh  $(BASHRCD)/aliases.sh
	$(LN) $(PRJ)/bashrc.d/aws_functions.sh $(BASHRCD)/aws_functions.sh
	$(LN) $(PRJ)/bashrc.d/bash_functions.sh $(BASHRCD)/bash_functions.sh
	$(LN) $(PRJ)/bashrc.d/bash_powerline.sh $(BASHRCD)/bash_powerline.sh
	$(LN) $(PRJ)/bashrc.d/editor.sh  $(BASHRCD)/editor.sh
	$(LN) $(PRJ)/bashrc.d/fzf.sh  $(BASHRCD)/fzf.sh
	$(LN) $(PRJ)/bashrc.d/git_aliases.sh $(BASHRCD)/git_aliases.sh
	$(LN) $(PRJ)/bashrc.d/git_functions.sh $(BASHRCD)/git_functions.sh
	$(LN) $(PRJ)/bashrc.d/go.sh $(BASHRCD)/go.sh
	$(LN) $(PRJ)/bashrc.d/ohmyzsh_git_aliases.sh  $(BASHRCD)/ohmyzsh_git_aliases.sh
	$(LN) $(PRJ)/bashrc.d/packer.sh $(BASHRCD)/packer.sh
	$(LN) $(PRJ)/bashrc.d/ssh_aliases.sh $(BASHRCD)/ssh_aliases.sh
	$(LN) $(PRJ)/bashrc.d/temp_aliases.sh  $(BASHRCD)/temp_aliases.sh
	$(LN) $(PRJ)/bashrc.d/terragrunt_aliases.sh  $(BASHRCD)/terragrunt_aliases.sh
	$(LN) $(PRJ)/bashrc.d/tmux_aliases.sh $(BASHRCD)/tmux_aliases.sh
	$(LN) $(PRJ)/bashrc.d/docker.sh $(BASHRCD)/docker.sh
	$(LN) $(PRJ)/bashrc.d/pyenv.sh $(BASHRCD)/pyenv.sh
	-$(LN) $(PRJ)/bashrc.d/work_aliases.sh $(BASHRCD)/work_aliases.sh
	sed -i.$(EPOCH) '/\.bashrc\.local/d' $(HOME)/.bashrc
	echo '. $(HOME)/.bashrc.local' >> $(HOME)/.bashrc
	$(LN) $(PRJ)/bashrc.local $(HOME)/.bashrc.local

gitconfig: ## deploy user gitconfig
	$(LN) $(PRJ)/gitconfig $(HOME)/.gitconfig

gpg: home ## download gpg scripts
	curl --silent -o $(BIN)/encrypt https://raw.githubusercontent.com/natemarks/pipeline-scripts/main/scripts/encrypt
	curl --silent -o $(BIN)/decrypt https://raw.githubusercontent.com/natemarks/pipeline-scripts/main/scripts/decrypt
	chmod 755 $(BIN)/encrypt
	chmod 755 $(BIN)/decrypt

stayback: ## configure stayback
	$(MKDIR) $(HOME)/.stayback
	$(HOME)/bin/decrypt $(PWD)/stayback.json.gpg
	$(LN) $(PRJ)/stayback.json  $(HOME)/.stayback.json

vim: ## configure vim
	$(LN) $(PRJ)/vim/vimrc  $(HOME)/.vimrc

shellcheck: ## shellcheck project files. skip ohmyzsh_git_aliases.sh file
	find . -type f -name "*.sh" ! -name 'ohmyzsh_git_aliases.sh' -exec "shellcheck" "--format=gcc" {} \;
	shellcheck --format=gcc bin/encrypt
	shellcheck --format=gcc bin/decrypt

packages: ## install required packages
    # dconf/uuid for gogh colors
	sudo apt-get install -y \
	curl \
	git \
	tree \
	make \
	wget \
	zip \
	unzip \
	seahorse-nautilus \
	fzf \
	ripgrep \
	silversearcher-ag \
	jq \
	fonts-powerline \
	dconf-cli \
	uuid-runtime \
	tmux \
	shellcheck \
	hunspell \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	llvm \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libxml2-dev \
	libxmlsec1-dev \
	libffi-dev \
	liblzma-dev \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
	gnupg \
	lsb-release \
	python3.8-venv \
	postgresql-client \
	xclip \
	heif-gdk-pixbuf;

vscode: ## install vscode
	bash scripts/install_vscode.

$(HOME)/.tmux/plugins/tpm: ## clone tmux-plugins
	git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm


$(HOME)/.tmux.conf: $(HOME)/.tmux/plugins/tpm ## configure tmux
	$(LN) $(PRJ)/tmux/tmux.conf $(HOME)/.tmux.conf

neovim: $(HOME)/.tmux.conf ## install neovim
	bash scripts/install_neovim.sh
	-rm -rf $(HOME)/.config/nvim
	mkdir -p $(HOME)/.config/nvim/lua
	mkdir -p $(HOME)/.config/nvim/after/plugin
	$(LN) $(PRJ)/neovim/init.lua $(HOME)/.config/nvim/init.lua
	$(LN) $(PRJ)/neovim/lua/options.lua $(HOME)/.config/nvim/lua/options.lua
	$(LN) $(PRJ)/neovim/lua/plugins.lua $(HOME)/.config/nvim/lua/plugins.lua
	$(LN) $(PRJ)/neovim/lua/pluginlist.lua $(HOME)/.config/nvim/lua/pluginlist.lua
	$(LN) $(PRJ)/neovim/after/plugin/lsp.lua $(HOME)/.config/nvim/after/plugin/lsp.lua
	$(LN) $(PRJ)/neovim/after/plugin/cmp.lua $(HOME)/.config/nvim/after/plugin/cmp.lua
	$(LN) $(PRJ)/neovim/after/plugin/telescope.lua $(HOME)/.config/nvim/after/plugin/telescope.lua
	$(LN) $(PRJ)/neovim/after/plugin/treesitter.lua $(HOME)/.config/nvim/after/plugin/treesitter.lua

lazygit: ## install lazygit
	bash scripts/install_lazygit.sh

ssh-config: ## ssh config
	$(LN) $(PRJ)/ssh/config  $(HOME)/.ssh/config

rm-bash: ## remove bashrc config before replacing
	-rm -rf $(BASHRCD)
	-rm -f $(HOME)/.bashrc.local

rm-gpg: ## cleanup gpg scripts before replacing
	-rm -f $(BIN)/encrypt
	-rm -f $(BIN)/decrypt

rm-powerline: ## remove the powerline files before replacing
	-rm -f $(POWERLINE)/colorschemes/default.json
	-rm -f $(POWERLINE)/themes/shell/default.json

rm-ssh-config: ## remove gitconfig before replacing
	-rm -f $(HOME)/.ssh/config

rm-gitconfig: ## remove gitconfig before replacing
	-rm -f $(HOME)/.gitconfig

remove-all: rm-bash rm-gpg rm-powerline rm-ssh-config rm-gitconfig ## destroy everything you love

all: packages gpg powerline bash gitconfig ssh-config ## configure everything
