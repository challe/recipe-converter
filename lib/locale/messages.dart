import "package:intl/intl.dart";

String header() =>
    Intl.message("Converts recipes", name: "header", args: [], desc: "");

String convertButton() =>
    Intl.message("Convert", name: "convertButton", args: [], desc: "");

String example() => Intl.message(
    "Example: http://www.foodnetwork.com/recipes/tyler-florence/spaghetti-alla-carbonara-recipe.html",
    name: "example",
    args: [],
    desc: "");

String converted() =>
    Intl.message("Converted", name: "converted", args: [], desc: "");

String placeholder() => Intl.message(
    "Paste a link, a list of ingredients, or write your own list!",
    name: "placeholder",
    args: [],
    desc: "");

String parseError() =>
    Intl.message("Could not fetch ingredients for this adress",
        name: "parseError", args: [], desc: "");

String howDoesItWork() =>
    Intl.message("How does it work?",
        name: "howDoesItWork", args: [], desc: "");