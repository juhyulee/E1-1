#!/bin/sh
set -eu

echo 'persistent data survives container deletion' > /data/result.txt
echo 'WRITTEN BY FIRST CONTAINER:'
cat /data/result.txt
ls -la /data
