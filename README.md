# Dotfiles

This repository serves as a centralized location for managing my personal configuration files (dotfiles) for various tools and applications. By using this repository, you can easily synchronize your configuration across multiple machines or share your preferred settings with others.

## Prerequisites

Before getting started, ensure you have the following tools installed:

- Git: To clone and manage the dotfiles repository.
- GNU Stow: A free, portable tool for managing the installation of software packages by creating symlinks.

## Getting Started

1. **Clone the Repository**

   Clone this repository to your home directory (`~/`):

   ```
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles
   ```

2. **Navigate to the Repository**

   Change your current working directory to the cloned `dotfiles` repository:

   ```
   cd ~/dotfiles
   ```

3. **Symlink a Configuration**

   To create symlinks for a package's configuration files in the appropriate locations in your home directory, use the `stow` command inside the `dotfiles` directory:

   ```
   stow .config/nvim
   ```

   This command will create symlinks for all files in the `.config/nvim` directory (which contains the Neovim configuration) inside your `~/.config/nvim` directory.

   You can repeat this step for any other configuration directory you wish to use, such as `zsh`, `tmux`, or `rustup`.

4. **Adopt Existing Configuration (Optional)**

   If you already have existing configuration files in your home directory and want to adopt them into the dotfiles repository, you can use the `--adopt` flag:

   ```
   mkdir -p ~/.config/nvim
   # Copy your existing Neovim configuration files to ~/.config/nvim
   stow --adopt .config/nvim
   ```

   This will move the existing files from `~/.config/nvim` into the `.config/nvim` directory in the dotfiles repository and create symlinks in their place.

## Directory Structure

The dotfiles repository has these configs:

- `nvim`: Neovim text editor, including plugins, keymaps, and color schemes.
- `zsh`: Z Shell (Zsh), including Oh My Zsh setup and custom aliases.
- `tmux`: Tmux terminal multiplexer.
- `rustup`: Rust toolchain installer.
- `copilot`: GitHub Copilot AI pair programming assistant.
