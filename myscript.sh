#!/bin/sh


curl -L -O http://openafs.org/dl/openafs/1.6.22.3/openafs-1.6.22.3-src.tar.gz
tar zxvf openafs-1.6.22.3-src.tar.gz
cd openafs-1.6.22.3
./configure --enable-transarc-paths
make
make dest
