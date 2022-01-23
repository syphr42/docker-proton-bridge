# ProtonMail Bridge

## Setup

### Generate GPG key

Proton bridge requires a GPG key to encrypt credentials.

First, create a new key specifically for the bridge without a password (do not use your personal key).
```
gpg --batch --passphrase '' --quick-gen-key 'ProtonMail Bridge' default default never
```

Next, export the new key as an armored ASCII file. You should keep this file secure since it has no password.
```
gpg --armor --export-secret-keys 'ProtonMail Bridge' > proton-bridge.asc
```

### Configure account

Now it is time to run the container for the first time. This will be an interactive experience to generate the login cache so you don't need to enter credentials each time.

Note that there are three interesting volumes to persist for subsequent container starts. The first two are required. The third can help performance, but is not strictly required.

1.  `/root/.config/protonmail/bridge` (configuration files)
2.  `/root/.password-store` (encryption cache)
3.  `/root/.cache/protonmail/bridge` (cache files)

Run Proton Bridge in interactive CLI mode so you can setup your login.
```
podman run --rm -it \
    --volume ~/.config/protonmail/bridge:/root/.config/protonmail/bridge \
    --volume ~/.cache/protonmail/password-store:/root/.password-store \
    --volume ~/.cache/protonmail/bridge:/root/.cache/protonmail/bridge \
    -e BRIDGE_GPG_KEY="$(cat proton-bridge.asc)" \
    syphr42/proton-bridge --cli
```

When the interface is running, type `login` and follow the prompts. Once login is complete, type `exit` to shutdown the bridge.

More information on command line options can be found here: https://protonmail.com/support/knowledge-base/bridge-cli-guide/

## Non-interactive

Once setup is complete (or a proper prefs.json file is supplied at `/root/.config/protonmail/bridge/prefs.json`), the bridge can be run in non-interactive mode.

```
podman run --rm -it \
    --volume ~/.config/protonmail/bridge:/root/.config/protonmail/bridge \
    --volume ~/.cache/protonmail/password-store:/root/.password-store \
    --volume ~/.cache/protonmail/bridge:/root/.cache/protonmail/bridge \
    -env BRIDGE_GPG_KEY="$(cat proton-bridge.asc)" \
    --publish 1025:1025 \
    --publish 1143:1143 \
    syphr42/proton-bridge --non-interactive
```
