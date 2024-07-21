{ ... }:
{
  users = {
    mutableUsers = true;
    users.nhp = {
      isNormalUser = true;
      description = "Nadia";
      extraGroups = [ "networkmanager" "wheel" "libvirt" ];
      # Just "password", CHANGE THIS
      initialHashedPassword = "$y$j9T$NFLtz5feFEkFr5OIkwNU4/$azHaTciuotCAEOPTcPgIwVogplflTk47xv8XzZFd/O5";
    };
  };
}
