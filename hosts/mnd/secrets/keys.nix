{ ... }:

{
  sops.secrets = {
    example_key = {
      owner = "breitnw";
    };
    example_number = {
      owner = "breitnw";
    };
    "accounts/mail/key" = {
      owner = "breitnw";
    };
  };
}
