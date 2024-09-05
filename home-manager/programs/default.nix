# { lib, ... }: let
#   filesIn = dir: lib.mapAttrs
#     (name: _: import (dir + "/${name}"))
#     (lib.filterAttrs)
# {
#   imports = [

#   ];
# }
