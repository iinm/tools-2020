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

#### Jedi.el (Python)

`pip install virtualenv` and `M-x jedi:install-server`.

#### JDEE (Java)

```sh
cd ~/.emacs.d/jdee/jdee-server
mvn assembly:assembly
```
