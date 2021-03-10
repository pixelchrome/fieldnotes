---
linkTitle: "ZSH"
weight: 260
---

# ZSH

Here is my zsh setup

## Install zsh

### macOS

```sh
brew install zsh-syntax-highlighting zsh-autosuggestions
```

### Ubuntu

```sh
apt install zsh zsh-autosuggestions zsh-syntax-highlighting
```

## Install **ohmyzsh**

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install P10k Theme

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Configure Theme

```sh
p10k configure
```