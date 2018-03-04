ZSH installation
=================

On Ubuntu System:

```
$ sudo apt-get install dconf-cli
$ git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
$ cd ~/.solarized
$ ./install.sh
```

- Choose option 1 (dark theme) which is just great.
- Choose option 1 to download seebi' dircolors-solarized

After installation, open .zprofile and add the line:

```
eval `dircolors ~/.dir_colors/dircolors`
```

