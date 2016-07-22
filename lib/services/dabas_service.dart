import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/browser_client.dart';
import '../models/models.dart';

@Injectable()
class DabasService {
  String _url = '';

  final BrowserClient _http;

  DabasService(this._http) {
    if (window.location.href.contains('challe.se')) {
      _url = "http://www.challe.se/converter/api/dabas/search";
    } else {
      _url = "http://localhost/converter/api/dabas/search";
    }
  }

  Future addNutritionToFoodstuff(List<String> texts) async {
    Completer c = new Completer();
    String data = JSON.encode(texts);

    final response = await _http.post(_url, body: data);
    String body = response.body;
    var added = JSON.decode(body);

    List<IngredientPart> ingredientParts = new List<IngredientPart>();
    added.forEach((nutrition) {
      window.console.log(nutrition["name"]);
      //ingredientParts.add(new IngredientPart())
      //ingredientPart.nutrition = new List<Nutrition>();
      //ingredientPart.nutrition.add(nutrition);
    });

    c.complete();

    return c.future;
  }
}
