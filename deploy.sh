#!/bin/bash

if [ $# -gt 1 -o $# -eq 0 ]; then
  echo "Usage: deploy.sh <PROCESS NAME>"
  exit 1
fi

function _deploy_bin() {
  local web_server=$1
  scp ./usr/sbin/monit root@$web_server:/usr/sbin/
}

function _mkdir_etc_monit() {
  local web_server=$1
  local command="ssh root@$web_server 'mkdir -p /etc/monit/conf.d/'"
  echo "$command"
  eval "$command"
}

function _deploy_monit_rc() {
  local web_server=$1
  scp ./etc/monit/monitrc root@$web_server:/etc/monit/
}

function _deploy_monit_gunicorn_conf() {
  local web_server=$1
  scp ./etc/monit/conf.d/gunicorn root@$web_server:/etc/monit/conf.d/
}

function _deploy_default_conf() {
  local web_server=$1
  scp ./etc/default/monit root@$web_server:/etc/default/
}

function _mkdir_var_monit() {
  local web_server=$1
  local command="ssh root@$web_server 'mkdir -p /var/monit'"
  echo "$command"
  eval "$command"
}

function _deploy_init_d() {
  local web_server=$1
  scp ./etc/init.d/monit root@$web_server:/etc/init.d/
}


function deploy() {
  WEB_SERVERS=$(cat /etc/web_server_list)

  for web_server in $WEB_SERVERS; do
    _deploy_bin $web_server
    _mkdir_etc_monit $web_server
    _deploy_monit_rc  $web_server
    _deploy_monit_gunicorn_conf $web_server
    _deploy_default_conf $web_server
    _mkdir_var_monit $web_server
    _deploy_init_d $web_server
  done
}

function start_monit_all_server() {
  WEB_SERVERS=$(cat /etc/web_server_list)

  for web_server in $WEB_SERVERS; do
    local command="ssh root@$web_server /etc/init.d/monit start"
    echo "$command"
    eval "$command"
  done
}

case "$1" in
    deploy)
        deploy
        start_monit_all_server
        ;;
    *)
        echo $"Usage: $0 {deploy}"
        RETVAL=1
esac
exit $RETVAL
