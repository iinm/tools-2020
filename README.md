# etc

Configuration files (a.k.a. dotfiles)

## Installation

```sh
git clone --recursive https://github.com/iinm/etc.git ~/.etc
cd ~/.etc
bash link.sh
# or
bash link.sh -f  # remove existing files
```

## Settings

### neovim

#### deoplete

```sh
pip3 install -U neovim
pip3 install -U jedi  # for deoplete-jedi
```

### Emacs

#### xclip (on Linux)

Install xclip to use X clipboard.
