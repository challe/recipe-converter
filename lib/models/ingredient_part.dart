part of models;

enum IngredientPartType { measurement, type, foodstuff }

class IngredientPart {
  IngredientPartType type;
  String text;

  IngredientPart(this.type, this.text);
}
