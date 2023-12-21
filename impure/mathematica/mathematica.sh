#! /nix/store/rhvbjmcfnkg8i2dxpzr114cp1ws7f667-bash-5.2-p15/bin/bash -e
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+':'$LD_LIBRARY_PATH':'}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH/':''/nix/store/hr3m53r0nhyqx80sg0bz9xjgk6jg009k-zlib-1.2.13/lib'':'/':'}
LD_LIBRARY_PATH='/nix/store/hr3m53r0nhyqx80sg0bz9xjgk6jg009k-zlib-1.2.13/lib'$LD_LIBRARY_PATH
LD_LIBRARY_PATH=${LD_LIBRARY_PATH#':'}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH%':'}
export LD_LIBRARY_PATH
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+':'$LD_LIBRARY_PATH':'}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH/':''/nix/store/yazs3bdl481s2kyffgsa825ihy1adn8f-gcc-12.2.0-lib/lib'':'/':'}
LD_LIBRARY_PATH='/nix/store/yazs3bdl481s2kyffgsa825ihy1adn8f-gcc-12.2.0-lib/lib'$LD_LIBRARY_PATH
LD_LIBRARY_PATH=${LD_LIBRARY_PATH#':'}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH%':'}
export LD_LIBRARY_PATH
PATH=${PATH:+':'$PATH':'}
PATH=${PATH/':''/nix/store/7wkshj58fcsl1f3zyi67qsxgl1p8nki1-gcc-wrapper-12.2.0/bin'':'/':'}
PATH='/nix/store/7wkshj58fcsl1f3zyi67qsxgl1p8nki1-gcc-wrapper-12.2.0/bin'$PATH
PATH=${PATH#':'}
PATH=${PATH%':'}
export PATH
export USE_WOLFRAM_LD_LIBRARY_PATH='1'
export QT_XKB_CONFIG_ROOT='/nix/store/10yxc0fwgr5hfpx3fhj8mdcag2czzf4i-xkeyboard-config-2.33/share/X11/xkb'
#export QT_QPA_PLATFORM='xcb'
exec -a "$0" "/nix/store/4cspdl0wha0sf2qlpw2hs7r1w0bsr7mq-mathematica-13.2.1/libexec/Mathematica/Executables/.mathematica-wrapped"  "$@" 
