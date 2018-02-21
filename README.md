# NEC Aterm ルーターを再起動するだけの PHP スクリプト

## インストール

1. ダウンロードするか、"[rebooter.php](./blob/master/rebooter.php)"をコピーします。
2. ルーターの IP アドレスを変更し保存します。("rebooter.php" 内の `$ip_router=` の値)
3. アクセス権を `0755` に変更します。（`$ chmod 0755 ./rebooter.php`）

## 設定

`rebooter.php` 内のルーターのIPアドレスとパスワード（`$ip_router` と `$password` の値）を編集します。

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

