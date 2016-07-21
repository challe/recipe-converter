<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require "vendor/autoload.php";
require "config.php";

header('Access-Control-Allow-Origin: *');

$configuration = [
    'settings' => [
        'displayErrorDetails' => true,
    ],
];
$c = new \Slim\Container($configuration);
$app = new \Slim\App($c);
$app->get('/', function (Request $request, Response $response) {
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

    return json_encode($data, JSON_HEX_QUOT | JSON_HEX_TAG);
});

$app->get('/dabas/search/{ingredient}', function (Request $request, Response $response) use($dabasKey) {
    $ingredient = $request->getAttribute('ingredient');
    $ingredient = str_replace("+", "%20", urlencode($ingredient));
    $searchURL = "http://api.dabas.com/DABASService/V2/articles/searchparameter/" . $ingredient . "/JSON?apikey=" . $dabasKey;

    $value = "";
    $unit = "";
    $name = "";
    $kolhydrater = "";
    $found = false;

    $json = file_get_contents($searchURL);
    $articles = json_decode($json);

    if(count($articles) > 0) {
        $article = $articles[0];
        $GTIN = $article->GTIN;
        $name = $article->Artikelbenamning;

        // Find this specifig GTIN
        $gtinURL = "http://api.dabas.com/DABASService/V2/article/gtin/" . $GTIN . "/JSON?apikey=" . $dabasKey;
        $json = file_get_contents($gtinURL);
        $article = json_decode($json);

        if(count($article) > 0 && count($article->Naringsinfo) > 0) {
            for($i = 0; $i < count($article->Naringsinfo[0]->Naringsvarden); $i++) {
                $nutrition = $article->Naringsinfo[0]->Naringsvarden[$i];
                if($nutrition->Kod == "CHOAVL") {
                    $value = $nutrition->Mangd;
                    $unit = $nutrition->Enhet;
                    $kolhydrater = $value . " " . $unit;

                    $found = true;
                }
            }
        }
    }

    $data = array("found" => $found, "name" => $name, "value" => $value, "unit" => $unit, "kolhydrater" => $kolhydrater);

    return json_encode($data, JSON_HEX_QUOT | JSON_HEX_TAG | JSON_UNESCAPED_SLASHES);
});

$app->run();
?>