# secrets.nix
let
  laptop = "age1570ew8yl46dpnel9d2jetmuq6uq57sqlf4nz0ch29rzuakcva4ms67slqg";
in
{
  "github-token.age".publicKeys = [ laptop ];
}