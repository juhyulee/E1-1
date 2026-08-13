#!/bin/sh
set -eu

echo 'READ BY SECOND CONTAINER:'
cat /data/result.txt
ls -la /data
