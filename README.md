Automatic install and compile of MakeMKV for Linux/Ubuntu (Kodibuntu). Download the script,
make it executable (chmod u+x buildMakeMkv.sh) and run it (./buildMakeMkv.sh). When EULA 
appears, press "q" and "yes" and enter. Script will also install the latest beta key from
makemkv.com and check for updates. Key is stored in $HOME/.MakeMKV. You should run this 
script frequently in a period of two months. The script also changes the libaacs of kodi 
against the libmmbd of makemkv for better compatibility of BluRay ripping.

If you wish to overwrite/reinstall an acual version of makemkv, use option --force:

./buildMakeMkv.sh --force

If you want to generate a new keyfile only use options --force --keyonly:

./buildMakeMkv.sh --force --keyonly
