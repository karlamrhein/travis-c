#!/bin/sh
# Karl Amrhein

set -x
curl icanhazip.com
sudo iptables -nvL
ls -l /etc/ssh
ls -l /etc/ssh/sshd_config
whoami
# sudo cat /etc/ssh/sshd_config
# sudo service sshd start

sudo apt-get install lsof
sudo apt-get install nc
sudo chkconfig --list

sudo useradd -m ksa1
pass=`tr -dc 'a-z0-9' < /dev/urandom | head -c ${1:-32}`

/usr/bin/nc -z localhost 22

echo $pass | sudo passwd ksa1 

sudo ls -l /etc/sudoers.d/
sudo ls -l /etc/sudoers
sudo cat /etc/sudoers.d/travis
sudo cp /etc/sudoers.d/travis /etc/sudoers.d/ksa1
sudo sed -i -e 's/travis/ksa/g' /etc/sudoers.d/ksa1
sudo -l -U ksa1

while true; do
  printf "."
  sleep 60
done
  
exit




uname -a
df -h
curl icanhazip.com
which apt
which yum
echo sleeping for 5 seconds
sleep 5
which sshd
ls -l /etc/
find /etc/
find /usr/sbin
exit



# url='https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.10.1.tar.xz'
url='https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.20.2.tar.xz'

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
  if [ -x /opt/rh/devtoolset-7/enable ]; then
    echo Enabling GCC from Developer Toolset
    source /opt/rh/devtoolset-7/enable
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

