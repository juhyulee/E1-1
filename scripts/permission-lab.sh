#!/bin/sh
set -eu

mkdir -p /lab/permission-dir
touch /lab/permission-file.txt

echo '$ chmod 600 /lab/permission-file.txt'
chmod 600 /lab/permission-file.txt
stat -c '%A %a %n' /lab/permission-file.txt

echo '$ chmod 644 /lab/permission-file.txt'
chmod 644 /lab/permission-file.txt
stat -c '%A %a %n' /lab/permission-file.txt

echo '$ chmod 700 /lab/permission-dir'
chmod 700 /lab/permission-dir
stat -c '%A %a %n' /lab/permission-dir

echo '$ chmod 755 /lab/permission-dir'
chmod 755 /lab/permission-dir
stat -c '%A %a %n' /lab/permission-dir
