if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

function hms() {
	nix run github:nix-community/home-manager -- switch --flake ".#$(whoami)" -b hm-backup
}