# Personal Dotfiles

This repository contains my personal dotfiles for configuring my development environment on macOS.

## Usage
Clone this repository and symlink the relevant files to your home directory:

```sh
make setup-all
make setup-zshrc setup-git
```

## SSH Key Setup
To ensure SSH keys are loaded automatically and authenticated by the macOS keychain:

1. **Add all SSH key paths to your `.zprofile` and silence any output in new terminal sessions**
   - Example:
     ```sh
     ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github &>/dev/null
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

## Node.js Version Management with nvm

1. **Set your default Node.js version:**
   ```sh
   nvm alias default <node version>
   ```
   Replace `<node version>` with your desired version (e.g., `18`, `node`, etc.).

2. **Enable automatic switching to default:**
   - In your `node.zsh`, set `switch_to_default=true` inside the `nvm-switch` function. This ensures nvm reverts to the default version if no `.nvmrc` is found.

   ```sh
   nvm-switch() {
       # ...
       local switch_to_default=true
       # ...
   }
   ```

This setup ensures your default Node.js version is always loaded unless a project-specific `.nvmrc` is present. Otherwise, initially node binary will point to the `nvm alias default` version, and will not revert to default version if `.nvmrc` is not present.

## To-Do
- [ ] Use Stow
- [ ] Automate specific ssh key loading via zprofile (e.g. from ~/.ssh/autoload/*)