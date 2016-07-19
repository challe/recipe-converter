import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:http/browser_client.dart';

import '../models/models.dart';

@Injectable()
class RecipeService {
  String _url = '';

  final BrowserClient _http;

  RecipeService(this._http) {
    if (window.location.href.contains('challe.se')) {
      _url = "http://www.challe.se/converter/api/";
    } else {
      _url = "http://localhost/converter/api/";
    }
  }

  Future<List<String>> getRecipesToTest([String url = ""]) async {
    try {
      final response =
          await _http.get(_url + "?url=" + Uri.encodeComponent(url));
      Recipe recipe = new Recipe.fromJson(response.body);

      DomParser domParser = new DomParser();
      Document document = domParser.parseFromString(recipe.html, "text/html");

      List<String> urlsToTest = new List<String>();

      document.querySelectorAll("h2 a").forEach((element) {
        String href = element.attributes["href"];
        urlsToTest.add(href);
      });

      return urlsToTest;
    } catch (e) {
      //throw _handleError(e);

    }
  }

  Future<Recipe> getRecipe([String url = ""]) async {
    try {
      final response =
          await _http.get(_url + "?url=" + Uri.encodeComponent(url));
      Recipe recipe = new Recipe.fromJson(response.body);
      recipe.url = url;

      return recipe;
    } catch (e) {
      //throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    print(e); // log to console instead
    return new Exception('Server error; cause: $e');
  }
}
