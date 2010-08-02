# Contributor: ragnarok2040 at gmail dot com
# ps2sdk-ports-libpng PKGBUILD

pkgname=ps2sdk-ports-libpng
pkgver=1.4.3
pkgrel=1
pkgdesc="libpng for ps2sdk"
arch=('i686' 'x86_64')
license=('Custom')
url="http://www.ps2dev.org/"
depends=('ps2sdk-git' 'ps2sdk-ports-zlib')
makedepends=('cross-ps2-binutils>=2.14'
             'cross-ps2-ee-newlib>=1.10.0'
             'cross-ps2-ee-gcc'
             'cross-ps2-iop-gcc'
             'make' 'gcc' 'patch' 'subversion')
options=('!strip' '!libtool')
source=("http://downloads.sourceforge.net/sourceforge/libpng/libpng-$pkgver.tar.gz"
        Makefile)
md5sums=('df3521f61a1b8b69489d297c0ca8c1f8'
         '17224c4f63889793604ceaf1b4877bf5')

build() {
  # Setup PKGBUILD ps2dev environment
  source /etc/profile.d/ps2dev.sh

  cd $srcdir

  msg "Cleaning up sources..."
  rm -rf libpng-build || return 1

  msg "Copying sources..."
  cp -r libpng-$pkgver libpng-build
  cp Makefile libpng-build/

  cd libpng-build

  msg "Starting make..."
  make || return 1
  make DESTDIR=$pkgdir install || return 1

  # Install license for libpng
  install -m755 -D $srcdir/libpng-$pkgver/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
}
