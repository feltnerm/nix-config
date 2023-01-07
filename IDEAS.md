ideas
---

_Jot 'em down and never do 'em._

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
