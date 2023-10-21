# rewop.nvim

This is my nvim configuration. Started from the fork of the [kickstarter.vim](https://github.com/kdheepak/kickstart.nvim).


### Installation

Requirements:
* [ripgrep](https://github.com/BurntSushi/ripgrep#installation) is required for multiple [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.

Neovim's configurations are located under the following paths, depending on your OS: `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim`

Clone rewop.nvim:

```sh
git clone https://github.com/rewop/rewop.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

### Post Installation

Run the following command and then **you are ready to go**!

```sh
nvim --headless "+Lazy! sync" +qa
```

