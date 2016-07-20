import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import "package:converter/locale/translated_component.dart";
import 'package:converter/services/recipe_service.dart';
import '../../models/models.dart';
import '../../parser/parser.dart';
import '../../config/config.dart';

@Component(
    selector: 'search',
    templateUrl: 'search.html',
    providers: const [RecipeService])
class SearchComponent extends TranslatedComponent implements OnInit {
  Storage localStorage = window.localStorage;
  final RecipeService _pageService;
  final RouteParams _routeParams;
  Search model = new Search();

  SearchComponent(this._pageService, this._routeParams) {
    model.types = ConfigHelper.getReplacementTypes();

    model.header = text("Convert recipes", "header");
    model.convert = text("Convert", "convertButton");
    model.example = text(
        "Example: http://www.foodnetwork.com/recipes/tyler-florence/spaghetti-alla-carbonara-recipe.html",
        "example");
    model.converted = text("Converted", "converted");
    model.placeholder = text(
        "Paste a link, a list of ingredients, or write your own list!",
        "placeholder");
    model.parseError =
        text("Could not fetch ingredients for this adress", "parseError");
    model.howDoesItWork = text("How does it work?", "howDoesItWork");
  }

  ngOnInit() async {
    if (localStorage.containsKey(["type"])) {
      model.type = localStorage["type"];
    } else {
      model.type = model.types[0];
    }

    String url = _routeParams.get("url");
    if (url != null) {
      getRecipe(url);
    }
  }

  getRecipe(String input) async {
    bool isURL = false;
    String url = "";

    if (!localStorage.containsKey(["type"])) {
      localStorage["type"] = model.type;
    } else {
      if (localStorage["type"] != model.type) {
        localStorage["type"] = model.type;
      }
    }

    input = input.trim();

    try {
      if (!model.fetching || model.testing) {
        model.fetching = true;

        if (input.contains("http") || input.contains("www")) {
          isURL = true;
          url = input;

          if (!url.contains("http")) {
            url = 'http://' + url;
          }
        }

        if (isURL) {
          _pageService.getRecipe(url).then((recipe) {
            Parser.parseHTML(recipe, model.type).then((recipe) {
              model.currentUrl = url;

              if (window.location.href.contains('challe.se')) {
                model.recipes = new List<Recipe>();
              }
              model.recipes.add(recipe);

              model.fetching = false;
            });
          });
        } else {
          Parser.parseString(input, model.type).then((recipe) {
            if (window.location.href.contains('challe.se')) {
              model.recipes = new List<Recipe>();
            }
            model.recipes.add(recipe);

            model.fetching = false;
          });
        }
      }
    } catch (e) {
      model.fetching = false;

      window.console.error("Fel för url: $url");
      window.console.error(e);
      window.console.error(e.stackTrace);
    }
  }

  keyUpInput(KeyboardEvent keyboardEvent) {
    // Enter, backspace or delete
    if (keyboardEvent.keyCode == 8 || keyboardEvent.keyCode == 46) {
      setTextAreaHeight(true);
    } else if (keyboardEvent.ctrlKey && keyboardEvent.keyCode == 86) {
      setTextAreaHeight(true);
    }
  }

  keyDownInput(KeyboardEvent keyboardEvent) {
    if (keyboardEvent.keyCode == 13) {
      TextAreaElement textarea = document.querySelector("textarea");
      String text = textarea.value;

      if (text.contains("http") || text.contains("www")) {
        getRecipe(text);
        return false;
      } else {
        setTextAreaHeight(false);
      }
    }
  }

  setTextAreaHeight(bool backspace) {
    TextAreaElement textArea = document.querySelector("textarea");
    String text = textArea.value;

    List<String> rows = text.split("\n");
    int nrOfRows = rows.length;
    String height = "";

    // We pasted a string that is longer than one row, without line breaks
    if(text.length >= 75 && nrOfRows == 1) {
      nrOfRows = (text.length/60).ceil();
    }

    if (!backspace) {
      height = (42 + (nrOfRows * 20)).toString() + "px";
    } else {
      height = (22 + (nrOfRows * 20)).toString() + "px";
    }

    textArea.style.height = height;
  }

  Map<String, bool> setIngredientClasses(Ingredient ingredient) {
    final classes = {'replaced': ingredient.replacements.length > 0,};

    return classes;
  }

  Map<String, bool> setClasses(IngredientPart part) {
    final classes = {
      'part': true,
      'type': part.type.toString().contains("type"),
      'measurement': part.type.toString().contains("measurement"),
      'foodstuff': part.type.toString().contains("foodstuff")
    };

    return classes;
  }

  test() async {
    if (!model.testing) {
      model.testing = true;

      String query = "pasta+carbonara+recept";
      String testURL = "https://www.bing.com/search?q=" + query;
      List<String> urls = await _pageService.getRecipesToTest(testURL);

      Future.forEach(urls, (url) {
        this.getRecipe(url);
      }).then((_) {
        model.testing = false;
      });
    }
  }
}
