#!/usr/bin/env bash
set -euo pipefail

if [ -z "${BRIDGE_GPG_KEY}" ]; then
    echo "error: BRIDGE_GPG_KEY not defined"
    exit 1
fi

echo "Importing GPG key..."
gpg --batch --no-tty --import <(echo "${BRIDGE_GPG_KEY}")
echo "Done."
echo ""

echo "Adding owner trust to imported GPG key..."
gpg_key=$(gpg --batch --no-tty --list-keys --with-colons | awk -F: '/fpr:/ {print $10}' | sort -u | head -n 1 | tr -d '\n')
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "${gpg_key}" trust
echo "Done."
echo ""

if [ ! -d "${HOME}/.password-store" ] || [ -z "$(ls -A "${HOME}/.password-store")" ]; then
    echo "Initializing password store..."
    pass init "${gpg_key}"
    echo "Done."
    echo ""
fi

exec proton-bridge "$@"
