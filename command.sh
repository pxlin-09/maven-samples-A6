#!/bin/bash

mvn clean test
status=$?

if [ $status -eq 0 ]; then
  exit 0  
else
  exit 1  
fi
