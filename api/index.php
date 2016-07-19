<?php
header('Access-Control-Allow-Origin: *');

$html = null;

$urlParameter = $_GET["url"];
if($urlParameter == "") {
    $urlParameter = "http://www.koket.se/monikas-vardagsmat/monika-ahlberg/fajitas-pa-lovbiff/";
}

$html = @file_get_contents($urlParameter);
if($html == false) {
    $html = "";
}
$data = array("html" => $html);

echo json_encode($data, JSON_HEX_QUOT | JSON_HEX_TAG);

?>