# ProtonMail Bridge

## Generate GPG key
```
gpg --batch --passphrase '' --quick-gen-key 'ProtonMail Bridge' default default never
```

## Export armored GPG key
```
gpg --armor --export-secret-keys 'ProtonMail Bridge' > proton-bridge.asc
```

## Setup

https://protonmail.com/support/knowledge-base/bridge-cli-guide/

```
podman run --rm -it -v ~/.config/protonmail/bridge:/root/.config/protonmail/bridge -e BRIDGE_GPG_KEY="$(cat proton-bridge.asc)" proton-bridge --cli
```

## Non-interactive

Once setup is complete (or a proper prefs.json file is supplied at `/root/.config/protonmail/bridge/prefs.json`), the bridge can be run in non-interactive mode.

```
podman run --rm -it -v ~/.config/protonmail/bridge:/root/.config/protonmail/bridge -e BRIDGE_GPG_KEY="$(cat proton-bridge.asc)" proton-bridge --non-interactive
```
