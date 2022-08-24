let
  users = {
    mark_key1 = "age1yubikey1qgy3kkcq8t8ckhcjnccr6lsw5zaez56fncpz527wd3xsxw54lkqkym88r4n";
    mark_key2 = "age1yubikey1q0kxpuhkrx60acwjthrymndyqh3q9gx7xuurh8ppazncrtup3wv8vufxw45";
  };

  mark = [users.mark_key1 users.mark_key2];

  hosts = {
    monke = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/hukqpkuhPYUKaGJwpOielSNlgxxuqz/YCQNuSQ/Hu";
    markbook = "";
  };

  allHosts = [hosts.monke hosts.markbook];
in {
  # "root.passwd.age".publicKeys =  [ hosts.monke ];
  # "mark.secret.age".publicKeys = mark;
  # "secret2.age".publicKeys = [ mark markbook ];
  # "secret2.age".publicKeys = users ++ hosts;

  inherit users;
  inherit hosts;
}
