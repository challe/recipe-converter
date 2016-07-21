import 'dart:async';
import 'dart:html';

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

  Future<Nutrition> getNutrition(String ingredient) async {
    final response =
        await _http.get(_url + "/" + Uri.encodeComponent(ingredient));
    Nutrition nutrition = new Nutrition.fromJson(response.body);

    window.console.log(response.body);

    return nutrition;
  }
}
