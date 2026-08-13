#!/bin/sh
set -eu

echo '$ pwd'
pwd

echo '$ ls -la'
ls -la

echo '$ mkdir -p /lab/source'
mkdir -p /lab/source

echo '$ cd /lab'
cd /lab

echo '$ touch source/empty.txt'
touch source/empty.txt

echo '$ echo "hello terminal" > source/sample.txt'
echo "hello terminal" > source/sample.txt

echo '$ ls -la source'
ls -la source

echo '$ cat source/sample.txt'
cat source/sample.txt

echo '$ cp source/sample.txt copied.txt'
cp source/sample.txt copied.txt

echo '$ mv copied.txt renamed.txt'
mv copied.txt renamed.txt

echo '$ mkdir moved && mv source/sample.txt moved/renamed-sample.txt'
mkdir moved
mv source/sample.txt moved/renamed-sample.txt

echo '$ ls -la moved'
ls -la moved

echo '$ rm renamed.txt && rm -rf moved source'
rm renamed.txt
rm -rf moved source

echo '$ ls -la'
ls -la
