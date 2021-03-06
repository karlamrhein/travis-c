#!/bin/sh
# Karl Amrhein

tmpdir=/tmp
[ -d /scratch ] && tmpdir=/scratch   # use /scratch if possible

urls='https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.10.1.tar.xz
      https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.20.2.tar.xz'

for url in $urls; do
  echo "Working on $url ..."
  output=`mktemp --tmpdir=$tmpdir`       
  d=`mktemp -d --tmpdir=$tmpdir` || exit 1
  cd $d
  echo "using $d for build."
  # remove huge temp directory upon getting killed
  # this trap command does not seem to work during Travis CI builds
  # trap "cd /tmp; echo Removing $d; /bin/rm -rf $d" SIGTERM SIGINT
  
  curl -LO $url
  echo "Extracting tar ball..."
  tar xJf linux-4*
  /bin/rm -v *tar.xz
  cd linux-*
  echo "Starting make..."
  (make mrproper && make defconfig) 2>&1 >> $output
  echo "Continuing build..."
  (make 2>&1 >> $output ; mv $output ${output}.completed) &
  
  while [ -f $output ]; do
    tail -5 $output
    echo "..."
    sleep 30
  done
  
  echo "Build completed.  Log file is ${output}.completed"
  tail ${output}.completed
  find $d -name vmlinu\*
  set -x
  cd /tmp
  /bin/rm -rf $d
  set +x
done
