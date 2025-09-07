# Personal Dotfiles

This repository contains my personal dotfiles for configuring my development environment on macOS.

## SSH Key Setup
To ensure SSH keys are loaded automatically and authenticated by the macOS keychain:

1. **Add all SSH key paths to your `.zprofile` and silence any output in new terminal sessions**
   - Example:
     ```sh
     ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github &>/dev/null
     ssh-add --apple-use-keychain ~/.ssh/id_ed25519_gitlab &>/dev/null
     ```
2. **Configure your SSH keys in `~/.ssh/config`**
   - Example:
     ```
     Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519
       UseKeychain yes
       AddKeysToAgent yes
     ```
3. **macOS Keychain Integration**
   - The `UseKeychain yes` and `AddKeysToAgent yes` options in your SSH config ensure that your keys are stored in and loaded from the macOS keychain automatically.

## Usage
Clone this repository and symlink the relevant files to your home directory:

```sh
make all
make zshrc
make git
```
