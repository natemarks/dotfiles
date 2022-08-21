See New Build Procedure for initial configuration details. Everything works on Ubuntu 20.04 .  Initial tests with 22.04 are promising

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
Run make with no options to see the list of configuraiton options
```
make
```
To excute the configuration for the first time:
```shell
make all
```

If you need to update and re-run it, the make targets are not idempotent so you'll need to delete the files first:
```shell
make remove-all
```


## New Build Procedure


Installation
 - 4GB boot (for ample kernel upgrade space)
 - encrypted drive
 - name initial account adminnmarks. reserve for emergencies

 [upgrade firmware for laptopm and dock](https://support.lenovo.com/us/en/solutions/ht510810-how-to-do-software-updates-linux)

Install drivers
```
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
```

Install and run [makemine](https://github.com/natemarks/makemine). then run the command it suggest to create the normal use (not the initial admin) account

Switch to the normal account

### Install and configure 1Password (for ssh and gpg keys)
The ssh keys need to be setup before we can run the anyconnect role

https://github.com/natemarks/arole-onepassword

### Configure git/ssh/github

Create ssh private and public key files
```console
foo@bar:~$ vi ~/.ssh/my_ssh_private_key
foo@bar:~$ chmod 600 ~/.ssh/my_ssh_private_key
foo@bar:~$ ssh-keygen -f ~/.ssh/my_ssh_private_key -y > ~/.ssh/my_ssh_private_key.pub

```

Edit the add_ssh_key alais in bashrc.d/ssh_aliases.sh 
```
#!/usr/bin/env bash
alias add_ssh_key='ssh-add $HOME/.ssh/my_ssh_private_key'
```

Make sure the ssh-agent is running then run the add agent alias. You need to run this agent after rebooting.
```
foo@bar:~$ eval $(ssh-agent)
foo@bar:~$ add_ssh_agent
```
Configure ssh to use the private key for github.com. If you ran 'make all' these make targets were already run
```
make ssh-config
make gitconfig
```


### clone dotfiles 
```
mkdir -p ~/projects
cd ~/projects
git clone git@github.com:natemarks/dotfiles.git
```

### Import and trust gpg keys
Export/create the private key files from 1Password and import them.  You need to use the command line to get properly prompted for the passphrase
```console
foo@bar:~$ gpg --import gpg-private-nmarks-imprivata-com.key 
foo@bar:~$ gpg --import gpg-private-npmarks-gmail-com.key 
foo@bar:~$ gpg --list-keys
/home/nmarks/.gnupg/pubring.kbx
-------------------------------
pub   ed25519 2022-01-29 [SC] [expires: 2024-01-29]
      E003CE06B8BEFE9A9D4DFC9DBF93336BFF040C0E
uid           [ unknown] Nathan Marks <nmarks@imprivata.com>
sub   cv25519 2022-01-29 [E] [expires: 2024-01-29]

pub   ed25519 2022-01-29 [SC] [expires: 2024-01-29]
      49F4D75E877FDC3CA1DB2CA0D6D259FDB87ACF43
uid           [ unknown] Nate Marks <npmarks@gmail.com>
sub   cv25519 2022-01-29 [E] [expires: 2024-01-29]


# restart the keying daemon to get the keys to show up in s\Ubuntu Seahorse (Passwords and Keys)
foo@bar:~$ gnome-keyring-daemon -r -d

foo@bar:~$ gpg --edit-key E003CE06B8BEFE9A9D4DFC9DBF93336BFF040C0E
gpg (GnuPG) 2.2.19; Copyright (C) 2019 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  ed25519/BF93336BFF040C0E
     created: 2022-01-29  expires: 2024-01-29  usage: SC  
     trust: unknown       validity: unknown
ssb  cv25519/1E3B8954E259F42D
     created: 2022-01-29  expires: 2024-01-29  usage: E   
[ unknown] (1). Nathan Marks <nmarks@imprivata.com>

gpg> trust
sec  ed25519/BF93336BFF040C0E
     created: 2022-01-29  expires: 2024-01-29  usage: SC  
     trust: unknown       validity: unknown
ssb  cv25519/1E3B8954E259F42D
     created: 2022-01-29  expires: 2024-01-29  usage: E   
[ unknown] (1). Nathan Marks <nmarks@imprivata.com>

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y

```

### install vscode 
install 
configure sync
