part of models;

enum IngredientPartType { measurement, type, foodstuff }

class IngredientPart {
  IngredientPartType type;
  String text;
  List<Nutrition> nutrition;

  IngredientPart(this.type, this.text) {
    this.nutrition = new List<Nutrition>();
  }
}
