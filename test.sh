#!/usr/bin/env bash

function sshtunnel {
  ps -ef | grep -iq "[s]sh -fnl"
}

count=0
# Chain tests together by using &&
until ( sshtunnel)
do
  ((count++))
  if [ ${count} -gt 50 ]
  then
    echo "Services didn't become ready in time"
    exit 1
  fi
  sleep 0.1
done
echo worked