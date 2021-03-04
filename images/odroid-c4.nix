{ lib
, buildImage
, uboot
, aarch64Image
, extraConfig ? {}
}:

let
  # https://wiki.odroid.com/odroid-c4/software/partition_table
  ubootOffset = 512; # 1 block
  ubootSize = 512 * 2048; # 1M worth of blocks 
in buildImage {
  config = {
    imports = [ extraConfig ];
    format = "gpt";
    partitions = {
      uboot = {
        source = "${uboot}/u-boot.itb";
        size = ubootSize;
        start = ubootOffset;
      };
      nixos = {
        source = aarch64Image;
        start = ubootOffset + ubootSize;
        attrs = "LegacyBIOSBootable";
        useBootPartition = true;
      };
    };
  };
}
