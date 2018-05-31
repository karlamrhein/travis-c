#!/bin/sh

url='https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.10.1.tar.xz'

tmpdir=/tmp
[ -d /scratch ] && tmpdir=/scratch   # use /scratch if possible

output=`mktemp --tmpdir=$tmpdir`
        
d=`mktemp -d --tmpdir=$tmpdir` || exit 1
cd $d
echo "using $d for build."
# remove huge temp directory upon getting killed
trap "cd /tmp; echo Removing $d; /bin/rm -rf $d" SIGINT SIGTERM

{
  echo Starting at `date`

  #-----------------------------------------
  # to enable newer gcc from software collections:
  #-----------------------------------------
  if [ -x /opt/rh/devtoolset-4/enable ]; then
    echo Enabling GCC from Developer Toolset
    source /opt/rh/devtoolset-4/enable
  fi

  #-----------------------------------------
  echo Downloading kernel tar ball
  #-----------------------------------------
  curl -LO $url

  #-----------------------------------------
  echo Unpacking tar ball
  #-----------------------------------------
  tar xvJf linux-4*
  /bin/rm -v *tar.xz
  cd linux-*

  #-----------------------------------------
  echo Running make
  #-----------------------------------------
  make mrproper
  make defconfig
  make

  echo Ending at `date`
  cd /tmp
  /bin/rm -rf $d

} 2>&1 | tee $output

