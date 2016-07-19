part of models;

class Recipe {
  String html;
  Document document;
  String title;
  String url;
  String findMethod;
  Amount amount;
  List<RecipePart> recipeParts;

  bool hasReplacements() {
    return getIngredientsWithReplacements().length > 0;
  }

  List<Ingredient> getIngredientsWithReplacements() {
    List<Ingredient> ingredients = new List<Ingredient>();

    recipeParts.forEach((part) {
      part.ingredients.forEach((ingredient) {
        if (ingredient.replacements.length > 0) {
          ingredients.add(ingredient);
        }
      });
    });

    return ingredients;
  }

  Recipe() {
    this.recipeParts = new List<RecipePart>();
  }

  Recipe.fromJson(String input) {
    Map data = JSON.decode(input);
    html = data['html'];
    recipeParts = new List<RecipePart>();
  }
}
