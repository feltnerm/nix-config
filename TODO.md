TODO
---

_Lots to do here ..._

Non-exhaustive, semi-prioritized list of things left to do in this repo:

- development environment
    - continue porting
        - ~/code and git/github user setup?
    - vim / neovim config
    - emacs / spacemacs ??
- GUI
- rclone
    - system
        - secrets for age ?
        - import pubkeys - caddy server
        - secrets
            - passworded caddy server on local network?
    - home
        - gdrive personal
        - secrets for age?
        - caddy server?
- Secrets management
- Identity management
    - integration w/ GitHub
    - SSH keys
    - GPG keys
    - keybase
- macOS home-manager configuration
- Raspberry Pi nixosSystem
- other OS support


---

Key setup:

- sudo key
    - used to manage systems and users - e.g., access to rclone secrets folder
        - rclone service account
    - YubiKey compatibility
        - otherwise, shall be used internally only
- home-manager user keys
    - used for giving this user access to github, other servers, etc.
    - intelligent provisioning
    - stored encrypted in masaq-rclone secrets `${user}@${hostname}` folder -
      mounted with r/w access
    - pubkeys stored in masaq-rclone pubkeys folder - symlinked to ssh dir
    - can read other users' pubkeys
