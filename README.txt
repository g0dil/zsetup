SETUP INSTRUCTIONS

Symlink .zshenv from .zsetup to the home directory:

$ cd
$ ln -s .zsetup/.zshenv

If the default shell shall not be replaced, you can add the following two lines to the start of .profile:

> # change login shell depending on loging SSH key
> [ -r $HOME/.zsetup/zsh-ssh-switch.sh ] && source $HOME/.zsetup/zsh-ssh-switch.sh

