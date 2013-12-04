#!/bin/bash

# launch bats tests
export PYTHONPATH=/usr/lib/python2.7:$PYTHONPATH
bats tests
