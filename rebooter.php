<?php //utf-8
/*
------------------------------------------------------------------------
    NEC Aterm WG1200H シリーズ用再起動スクリプト

    ルーターの設定
------------------------------------------------------------------------
*/

$ip_router = '192.168.0.1';
$user      = 'admin';
$password  = '';

/*
------------------------------------------------------------------------
    再起動スクリプト
------------------------------------------------------------------------
*/

set_env_utf8_ja();

if (ob_get_contents() || ob_get_length()) {
    ob_end_clean();
}

$url_base = "http://${user}:${password}@${ip_router}";
$url_get  = $url_base . '/reboot.htm';
$url_post = $url_base . '/boafrm/formReboot';

// router
if (false == echo_status_router($ip_router)) {
    die();
}

// reboot.htm の取得
$html_file = file_get_contents($url_get);
$html_file = mb_convert_encoding($html_file, 'utf-8', 'euc-jp');

// セッションID の取得
echo 'セッションIDを取得します';
$dom_document = new DOMDocument();
@$dom_document->loadHTML(mb_convert_encoding($html_file, 'HTML-ENTITIES', 'UTF-8'));
$xml_object = simplexml_import_dom($dom_document);
$session_id = (string) $xml_object->xpath('//form/input')[0]['value'];

echo ": ${session_id}" . PHP_EOL;

// POSTするデータ
$str_reboot = mb_convert_encoding('再起動 ', 'euc-jp');
$data = http_build_query([
            'SESSION_ID' => $session_id,
            'reboot'     => $str_reboot,
        ]);
//preg_replace('/%5B(\d+?)%5D/', '', $params);

// header
$header = [
    "Origin: ${url_base}",
    'Accept-Encoding: gzip, deflate',
    'Accept-Language: ja,en-US;q=0.8,en;q=0.6',
    'Content-Type: application/x-www-form-urlencoded',
    'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Cache-Control: max-age=0',
    "Referer: ${url_get}",
    'Connection: keep-alive',
];

$context = [
    "http" => [
        "method"  => "POST",
        "header"  => implode("\r\n", $header),
        "content" => $data,
    ]
];

// POST 実行
$html_result = file_get_contents($url_post, false, stream_context_create($context));
$html_result = mb_convert_encoding($html_result, 'utf-8', 'euc-jp');

if (strpos($html_result, '再起動中') === false) {
    echo '再起動に失敗しました。' . PHP_EOL;
    echo $html_result . PHP_EOL;
    die();
}

// 再起動開始
$count = 0;
echo '再起動を開始しました。' . PHP_EOL;

// ダウンまで待機
while (ping($ip_router)) {
    sleep(1);
    $status = $is_up ? '応答あり' : '応答なし';
    echo "起動中：${count}sec: ${status}\r";
    $count++;
}

// アップまで待機
while (true) {
    sleep(1);
    $is_up = ping($ip_router);
    $status = $is_up ? '応答あり' : '応答なし';
    echo "起動中：${count}sec: ${status}\r";
    if($is_up){
        break;
    }
    $count++;
}

echo PHP_EOL;
echo 'ルーターの再起動が完了しました。' . PHP_EOL;

die();

/*
------------------------------------------------------------------------
    ユーザー関数
------------------------------------------------------------------------
*/

function echo_status_router($ip_router)
{
    $is_up  = ping($ip_router);
    $status = $is_up ? 'ルーターの稼働を確認しました。' : 'ルーターが応答しません。';
    echo $status . PHP_EOL;

    return $is_up;
}

function ping($host)
{
    $r = exec(
        sprintf('ping -c 1 -W 5 %s', escapeshellarg($host)),
        $res,
        $rval
    );

    return $rval === 0;
}

function set_env_utf8_ja($timezone = 'Asia/Tokyo')
{
    if (! function_exists('mb_language')) {
        die('This application requires mb_language.');
    }

    date_default_timezone_set($timezone);
    setlocale(LC_ALL, 'ja_JP');
    mb_language('ja');
    mb_internal_encoding('UTF-8');
    mb_http_output('UTF-8');
}
