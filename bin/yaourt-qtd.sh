#!/usr/bin/env sh
# Delete unused dependency packages with yaourt.

# Original version.
# Fails ugly if there are no packages from the first yaourt command.
#yaourt -Qtd | awk '{ print $1 }' | sed -e 's/.*\///' | yaourt -Rs -

# Second version
#pkgs=$(yaourt -Qtd | awk '{ print $1 }' | sed -e 's/.*\///')
#
#echo "Unused packages: ${pkgs}"
#if [ -n "$pkgs" ]; then
#	yaourt -Rs "$pkgs"
#fi

# Third version
# Yaourt now asks if these packages should be removed with -Rcs already, so really no need for this script!
yaourt -Qtd
