SETUP INSTRUCTIONS

Symlink .zshenv from .zsetup to the home directory:

$ cd
$ ln -s .zsetup/.zshenv

If you want to set a custom hostname to show in the prompt, add a file .zhost to your home:

$ echo "HOST=my-hostname" > .zhost

If the default shell shall not be replaced, you can add the following two lines to the start of .profile:

> # change login shell depending on loging SSH key
> [ -r $HOME/.zsetup/zsh-ssh-switch.sh ] && source $HOME/.zsetup/zsh-ssh-switch.sh

