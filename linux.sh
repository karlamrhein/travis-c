#!/bin/sh
# Karl Amrhein

tmpdir=/tmp
[ -d /scratch ] && tmpdir=/scratch   # use /scratch if possible

urls='https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.10.1.tar.xz
      https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.20.2.tar.xz'

for url in $urls; do
 
  output=`mktemp --tmpdir=$tmpdir`
        
  d=`mktemp -d --tmpdir=$tmpdir` || exit 1
  cd $d
  echo "using $d for build."
  # remove huge temp directory upon getting killed
  trap "cd /tmp; echo Removing $d; /bin/rm -rf $d" SIGINT SIGTERM

  {
    echo Starting at `date`
    curl -LO $url
    tar xvJf linux-4*
    /bin/rm -v *tar.xz
    cd linux-*
    make mrproper && make defconfig && make

    echo Ending at `date`
    cd /tmp
    /bin/rm -rf $d

  } 2>&1 | tee $output

