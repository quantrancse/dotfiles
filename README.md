# Debian dotfiles
Base on E7 dotfiles with some modifications

### Screenshot

![last screenshot](https://i.imgur.com/ic4wdJC.jpg)

### Install (debian strech 9.5):

* Install debian base (without X desktop).

* Install required packages:

    ```sh
    $ apt-get install i3 rxvt-unicode-256color lightdm x11-xserver-utils
    $ apt-get install git vim
    $ apt-get install conky curl alsa-utils
    $ apt-get install notification-daemon xinput

    ```

* Delete all files in $HOME and clone git then move all to $HOME:

    ```sh
    $ git clone https://github.com/quantrancse/dotfiles.git .
    ```

* Install vim plugins:

    ```sh
    $ git clone https://github.com/gmarik/Vundle.git ~/.vim/bundle/Vundle.vim
    $ vim +PluginInstall +qall
    ```

* Install lemonbar:

    ```sh
    $ mkdir tmp; cd tmp
    $ git clone  https://github.com/PH111P/bar.git
    $ apt-get install build-essential checkinstall
    $ apt-get install libxcb1-dev libxcb-xinerama0-dev libxcb-randr0-dev
    $ cd bar; make
    $ checkinstall -D make install
    ```

* Restart lightdm.    


