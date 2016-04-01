#!/bin/bash

if [ $# -gt 1 -o $# -eq 0 ]; then
  echo "Usage: init.sh <PROCESS NAME>"
  exit 1
fi

PROCESS_NAME=$1

# BSD, GNUどちらでも動くはず
sed -i '' -e "s/PROCESS_NAME/$PROCESS_NAME/g" ./etc/monit/conf.d/gunicorn

echo "/etc/monit/conf.d/gunicorn を置換したよ!"
echo "-------------------------------------------------------------------------"
cat ./etc/monit/conf.d/gunicorn
echo "-------------------------------------------------------------------------"
