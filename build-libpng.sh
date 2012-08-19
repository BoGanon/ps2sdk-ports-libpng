#!/bin/sh

# Trying to generalize it a bit so I don't need to modify it all that much
# per package

# Custom variables
_PKGNAME="ps2sdk-ports-libpng"
_PKGVER="1.5.12"
_SOURCE="http://downloads.sourceforge.net/sourceforge/libpng/libpng-${_PKGVER}.tar.xz"

# Various handy variables
_TOPDIR="${PWD}"
_SRCDIR="${PWD}/src"
_PKGDIR="${PWD}/${_PKGNAME}"
_SOURCEFILE=`basename ${_SOURCE}`
_SOURCEFN="${_SOURCEFILE%.*.*}"

# Sources needed to build package
# Not as good as I'd like
echo "\033[01;36mDownloading sources...\033[00m"
if [ -f ${_SOURCEFILE} ]; then
	echo "${_SOURCEFILE} found."
else
	wget -N ${_SOURCE}
fi

echo "\033[01;36mChecking for source directory...\033[00m"
if [ -d "${_SRCDIR}" ]; then
	echo "${_SRCDIR} found."
	echo "Removing..."
	rm -r "${_SRCDIR}"
else
	echo "${_SRCDIR} not found."

fi

echo "\033[01;36mChecking for package directory...\033[00m"
if [ -d "${_PKGDIR}" ]; then
	echo "${_PKGDIR} found."
	echo "Removing..."
	rm -r "${_PKGDIR}"
else
	echo "${_PKGDIR} not found."
fi

mkdir "${_SRCDIR}"
mkdir "${_PKGDIR}"

echo "\033[01;36mExtracting sources to src directory...\033[00m"

_TAROPT="z"
if [ "${_SOURCEFILE##*.}" = "gz" ]; then
	_TAROPT="z"
elif [ "${_SOURCEFILE##*.}" = "bz2" ]; then
	_TAROPT="j"
elif [ "${_SOURCEFILE##*.}" = "xz" ]; then
	_TAROPT="J"
fi

cd ${_SRCDIR}
tar x${_TAROPT}f ../${_SOURCEFILE}
cd ${_TOPDIR}

# Put in the custom commands for building and packaging
echo "\033[01;36mBuilding package..\033[00m"

if [ -f /etc/profile.d/ps2dev.sh ]; then
	. /etc/profile.d/ps2dev.sh
else
	exit 0
fi

cd ${_SRCDIR}/${_SOURCEFN}
cp ../../Makefile .
cp ../../pngusr.h .

make || return 1
make DESTDIR=${_PKGDIR} install || return 1
make clean

# End putting custom commands
echo "\033[01;36mInstalling DEBIAN package files...\033[00m"
install -m755 -d ${_PKGDIR}/DEBIAN
cp -r ${_TOPDIR}/DEBIAN/ ${_PKGDIR}

echo "\033[01;36mCreating DEBIAN package...\033[00m"
cd ${_TOPDIR}
dpkg-deb -z8 -Zgzip --build ${_PKGNAME}

exit 0

