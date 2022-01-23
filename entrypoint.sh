#!/usr/bin/env bash

if [ -z "${BRIDGE_GPG_KEY}" ]; then
    echo "error: BRIDGE_GPG_KEY not defined"
    exit 1
fi

echo "Importing GPG key..."
gpg --batch --import <(echo "${BRIDGE_GPG_KEY}")
echo "Done."
echo ""

echo "Adding owner trust to imported GPG key..."
for fpr in $(gpg --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u); do
    echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "${fpr}" trust
done
echo "Done."
echo ""

exec proton-bridge "$@"
