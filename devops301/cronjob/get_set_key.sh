#!/usr/bin/env bash

val="key"$RANDOM
echo "set $val 0 900 9"
echo "memcached"
sleep 1
echo "get $val"
sleep 2
echo "delete $val"
sleep 1
