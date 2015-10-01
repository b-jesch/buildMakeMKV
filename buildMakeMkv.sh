#!/bin/sh

cd /tmp/
wget "http://www.makemkv.com/download/"
export curr_version=$(grep -m 1 "MakeMKV v" index.html | sed -e "s/.*MakeMKV v//;s/ (.*//")

echo "Scraped the MakeMKV download page and found the latest version as" ${curr_version}
if [ -d $HOME/.MakeMKV/ ]; then
    echo "Destination for makemkv configs exists..."
else
    mkdir $HOME/.MakeMKV
fi

if [ -e $HOME/.MakeMKV/$curr_version ] && [ "$1" != "--force" ]; then
    echo "makemkv is up to date, no new version needed"
    exit 0
fi

wget "http://www.makemkv.com/forum2/viewtopic.php?f=5&t=1053"
key=`grep -Po '(?<=<div class="codecontent">).*?(?=<\/div>)' viewtopic.php\?f\=5\&t\=1053`
echo "Getting new key: $key"
echo "Generate new key file"

export keyfile=$HOME/.MakeMKV/settings.conf

echo "app_Key=\"$key\"" > $keyfile
if [ "$2" = "--keyonly" ]; then
    exit 0
fi

sudo apt-get install checkinstall build-essential libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev g++ pkgconf

export bin_zip=makemkv-bin-${curr_version}.tar.gz
export oss_zip=makemkv-oss-${curr_version}.tar.gz
export oss_folder=makemkv-oss-${curr_version}
export bin_folder=makemkv-bin-${curr_version}

wget http://www.makemkv.com/download/$bin_zip
wget http://www.makemkv.com/download/$oss_zip

tar -xzvf $bin_zip
tar -xzvf $oss_zip

cd $oss_folder
./configure -q
make -j`nproc` -s
sudo checkinstall -y make install

cd ../$bin_folder
make -j`nproc` -s
sudo checkinstall -y make install

cd ..

touch $HOME/.MakeMKV/$curr_version

echo removing downloaded files...
rm index.html
rm viewtopic.php\?f\=5\&t\=1053
rm $bin_zip
rm $oss_zip
rm -rf $oss_folder
rm -rf $bin_folder

echo "Linking to makeMKVs libmmbd"
cd /usr/lib/
sudo find . -name libaacs* -type f -delete
sudo ln -s -f libmmbd.so.0 libaacs.so.0
sudo ln -s -f libmmbd.so.0 libbdplus.so.0
