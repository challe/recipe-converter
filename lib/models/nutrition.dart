part of models;

class Nutrition {
  int value;
  String unit;
  String text() => value.toString() + " " + unit;

  Nutrition.fromJson(String input) {
    Map data = JSON.decode(input);
    value = data['value'];
    unit = data['unit'];
  }
}