#!/usr/bin/awk -f

docker container ls | awk '(NR == 2) {print $1}'
