#!/bin/sh -n

INFERNO_PATH = /usr/inferno/parallel
USER_CODE_PATH = /usr/inferno/parallel/user.sh

os interpreter $USER_CODE_PATH
mv ../host.sh .
mv ../device* .
