# This script performs the installation steps necessary for testing the `gnu`
# toolchain.

# Get the number of bits from the ARCH.
if ($env:ARCH -eq 'i686') {
  $bits = '32'
} elseif ($env:ARCH -eq 'x86_64') {
  $bits = '64'
} else {
  throw "Unexpected ARCH: $env:ARCH"
}

# Write the appropriate mingw directory for the .cargo/config file.
C:\msys64\usr\bin\sed -i '' -e "s/BITS/$bits/" config

# Add the MinGW tools (e.g. GCC) to PATH for use by CMake.
$env:PATH = 'C:\msys64\mingw' + $bits + '\bin;' + $env:PATH

# Show which `pkg-config` command is used.
get-command pkg-config

# Create the `pacman` package cache directory to avoid a warning.
#
# Sources:
# - https://bbs.archlinux.org/viewtopic.php?id=9
# - https://github.com/open62541/open62541/issues/2068
C:\msys64\usr\bin\mkdir -p /var/cache/pacman/pkg

# Install `graphite2` and show that it is installed.
appveyor-retry C:\msys64\usr\bin\pacman --sync --sysupgrade --needed --noconfirm "mingw-w64-$env:ARCH-graphite2"
C:\msys64\usr\bin\pacman --query --info "mingw-w64-$env:ARCH-graphite2"
pkg-config --libs --cflags graphite2
