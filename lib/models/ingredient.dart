part of models;

class Ingredient {
  Element element;
  String text;
  String groupName;
  List<IngredientPart> parts;
  List<Recipe> replacements;

  String textWithParts() {
    String text = this.text;
    List<String> alreadyParsed = new List<String>();

    this.parts.forEach((ingredientPart) {
      String ingredientPartText = ingredientPart.text.trim();
      if (ingredientPart.type == IngredientPartType.foodstuff &&
          !alreadyParsed.contains(ingredientPartText)) {
        String html = " <span title='" +
            "Lämna ett förslag på omvandling för detta livsmedel" +
            "' class='foodstuff'>" +
            ingredientPartText +
            "</span>";

        text = text.replaceAll(ingredientPart.text, html);
        alreadyParsed.add(ingredientPartText);
      }
    });

    return text;
  }

  Ingredient(this.element, this.text) {
    this.parts = new List<IngredientPart>();
  }
}
