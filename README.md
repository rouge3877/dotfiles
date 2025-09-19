# Rouge's Dotfiles

## Usage

```bash
# git, npm is necessary
git clone https://github.com/rouge3877/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

1. Install dependencies
```bash
./dependencies.sh
./dependencies.sh -g
# or ./dependencies.sh cli/ssh cli/zsh ... for precise install
```

2. Setup
```bash
./setup.sh
# or ./setup.sh cli/ssh cli/zsh ... for precise setup
```

3. System config
```bash
sudo sys/*-conf.sh
```


## TODO
- [ ] Upgrade dependencies for any kind of package manager
- [ ] Add a script to install all dependencies
- [ ] Add better output for installation script
