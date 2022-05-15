#!/bin/bash
TARGET_DIR="/config"
SRC_FILE="/backups/init/dashboard.tar"
TEST_FILE="www/index.html"

cd $TARGET_DIR
if ! test -f $TEST_FILE; then
  echo "Installing $SRC_FILE"
  if test -f $SRC_FILE; then
    tar xf $SRC_FILE
  fi
fi
