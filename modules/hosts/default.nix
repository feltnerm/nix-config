_:
{
  # Host schema and inventory management
  den.hosts.x86_64-linux = {
    codemonkey = {};

    # laptop
    markbook = {};

    # wsl
    reddevil = {};

    # vms
    virtmark = {};
    virtmark-gui = {};

    # images
    livecd = {};
    livecd-gui = {};
  };

  # Schema validation for hosts
  den.schema.host = _: {
    # default includes for all hosts
    includes = [];

    # host options
    options = {};

    # host config
    config = {};
  };
}
