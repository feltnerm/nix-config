let
  # Personal admin key (from ~/.ssh/id_ed25519.pub via ssh-to-age)
  markPersonal = "";

  # Host keys (from /etc/ssh/ssh_host_ed25519_key.pub via ssh-to-age)
  codemonkey = "";
  markbook = "";
  reddevil = "";
  virtmark = "";
  virtmark_gui = "";
  livecd = "";
  livecd_gui = "";

in
{
  # Per-host system secrets: only for codemonkey and markbook per requirements
  "hosts/codemonkey/opencode-api-token.age".publicKeys = [ markPersonal codemonkey ];
  "hosts/markbook/opencode-api-token.age".publicKeys = [ markPersonal markbook ];

  # Per-user secret available across hosts where mark is present
  "users/mark/opencode-api-token.age".publicKeys = [ markPersonal codemonkey markbook reddevil virtmark virtmark_gui livecd livecd_gui ];
}
