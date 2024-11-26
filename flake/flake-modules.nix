_:
let
  feltnermFlakeModule = _: { imports = [ ./feltnerm ]; };
in
{
  imports = [ feltnermFlakeModule ];

  flake.flakeModules = {
    default = feltnermFlakeModule;
  };

}
