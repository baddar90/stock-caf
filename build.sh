export KBUILD_BUILD_USER=baddar90
export ARCH=arm64
export CROSS_COMPILE=$HOME/gcc-4.9/bin/aarch64-linux-android-

DIR=$(pwd)
BUILD="$HOME/build"
OUT="$HOME/out"
#NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" msm-perf-ailsa_ii_defconfig

echo "building kernel..."
make O="$BUILD" -j30

echo "building modules..."
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.gz-dtb" "$OUT/Image.gz-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"

echo "Image.gz-dtb & modules can be found in $BUILD"
