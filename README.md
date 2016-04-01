# monit_deploy

踏み台からshellのみでdeployできるようにする

## ENV

- Debian 6.0.10 で動作確認済

## PROCESS

### 踏み台の適当な場所にこのディレクトリまるごとコピー

```
$ rsync -avz --delete --exclude=.git --exclude=README.md . root@<HOST>/
```

### 踏み台で設定してdeploy.

```
$ ./init.sh <Your application process>
$ ./deploy.sh deploy
```

