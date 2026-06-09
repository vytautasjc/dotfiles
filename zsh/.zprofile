# SSH

ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github &>/dev/null

if [ -s "$ZDOTDIR/.zprofile.local" ]; then
    . "$ZDOTDIR/.zprofile.local"
fi