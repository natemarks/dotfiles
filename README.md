This project configures a bash environment on Ubuntu 20.04 to look exactly like mine. The make targets manage files you may already have. you'll need to explicitly delete or move them. The make targets DO NOT automatically
overwrite your stuff.

WARNING: The exception is that we directly edit your $(HOME)/.bashrc:
 - We backup $HOME/.bashrc to "$HOME/.bashrc.$EPOCH"
 - We delete lines that contain '.bashrc.local'  (to make the make target idempotent)
 - We append '. $(HOME)/.bashrc.local' to the end of that file
 - We try to create $HOME/.bashrc.local
 - We DO AUTOMATICALLY OVERWRITE $HOME/bin/encrypt, $HOME/bin/decrypt with gpg convenience scripts

## Install
Clone to your project directory
```shell
git clone git@github.com:sertvitas/dotfiles.git
```


## Usage
To excute the configuration for the first time:
```shell
make all
```

If you need to update and re-run it, the make targets are not idempotent so you'll need to delete the files first:
```shell
make remove-all
```
