![Build](https://github.com/syphr42/docker-proton-bridge/workflows/build-images/badge.svg)

# Supported tags and respective `Dockerfile` links

- [`2.3.0`, `latest` (*Dockerfile*)](https://github.com/syphr42/docker-proton-bridge/blob/main/Dockerfile)
- [`1.8.12` (*Dockerfile*)](https://github.com/syphr42/docker-proton-bridge/blob/main/Dockerfile)

# What is Proton Bridge?

Proton Bridge translates SMTP and IMAP client requests in ProtonMail API requests so that standard mail interactions work with ProtonMail's encrypted service.

Website: https://protonmail.com/bridge/
Source: https://github.com/ProtonMail/proton-bridge

# How to Use

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
    syphr/proton-bridge --cli
```

When the interface is running, type `login` and follow the prompts. Once login is complete, type `info 0` to retieve login details for interacting with the bridge.

Finally, type `exit` to shutdown the bridge.

More information on command line options can be found here: https://protonmail.com/support/knowledge-base/bridge-cli-guide/

## Non-interactive

Once setup is complete, the bridge can be run in non-interactive mode. Port 1025 is SMTP and port 1143 is IMAP.

```
podman run --rm -it \
    --volume ~/.config/protonmail/bridge:/root/.config/protonmail/bridge \
    --volume ~/.cache/protonmail/password-store:/root/.password-store \
    --volume ~/.cache/protonmail/bridge:/root/.cache/protonmail/bridge \
    -env BRIDGE_GPG_KEY="$(cat proton-bridge.asc)" \
    --publish 1025:1025 \
    --publish 1143:1143 \
    syphr/proton-bridge --noninteractive
```
