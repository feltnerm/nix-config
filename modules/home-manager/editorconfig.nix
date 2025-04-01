{ config, lib, ... }:
{
  editorconfig = lib.mkIf config.editorconfig.enable {
    settings = {
      "*" = {
        "charset" = "utf-8";
        "end_of_line" = "lf";
        "trim_trailing_whitespace" = true;
        "insert_final_newline" = true;
      };
      "*.{json,yaml,yml,toml,tml}" = {
        "indent_style" = "space";
        "indent_size" = "2";
      };
      "Makefile" = {
        "indent_style" = "tab";
      };
    };
  };

}
