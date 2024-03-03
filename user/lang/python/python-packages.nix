{ pkgs, ... }:

{
  # Python packages
  home.packages = with pkgs.python3Packages; [
      cffi
      wheel
      chardet
      cryptography
      python-dateutil
      numpy
      pandas
      pillow
      pip
      pydantic
      requests
      six
  ];
}
