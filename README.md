# NEC Aterm ルーターを再起動するだけの PHP スクリプト

macOS の標準の PHP で NEC Aterm（WG1200Hxシリーズ）を再起動するスクリプトです。

[`bash` のシエル・スクリプト版](rebooter.sh)を利用した [macOS 用ルーター・再起動アプリの作り方](https://qiita.com/KEINOS/items/caf86f05607ff31ec886)は Qiita 記事をご覧ください。

## インストール

1. ダウンロードするか、"[rebooter.php](./blob/master/rebooter.php)"をコピーします。
2. アクセス権を `0755` に変更します。（`$ chmod 0755 ./rebooter.php`）

## 設定

`rebooter.php` 内の以下の項目を設定します。

|項目|値に入れる内容|入力例|
|:---|:---|:---|
|`$ip_router`|ルーターのIPアドレス|`192.168.100.1`|
|`$user` |管理者ログイン名|`admin`|
|`$password` |管理者ログインパスワード|`password`|

## 使い方

1. `$ php ./rebooter.php`

## 動作検証済み環境

|項目 |内容|
|:--:|:---|
|ルーター| NEC_Aterm_WG1200HS|
|OS| macOS HighSierra (OSX 10.13)|
|PC| MacBook Pro (Retina, 13-inch, Early 2015) |
|PHP| PHP 7.1.8 (cli) |
|Zend| Engine v3.1.0|

