#!/usr/bin/env sh
# Delete unused dependency packages with yaourt.


# Original version.
# Fails ugly if there are no packages from the first yaourt command.
#yaourt -Qtd | awk '{ print $1 }' | sed -e 's/.*\///' | yaourt -Rs -

# TODO problem is that this variable includes every package on a new line, plus that it prints out a question about removing with -Rcs options
pkgs=$(yaourt -Qtd | awk '{ print $1 }' | sed -e 's/.*\///')

echo "Unused packages: ${pkgs}"
if [ -n "$pkgs" ]; then
	yaourt -Rs "$pkgs"
fi
