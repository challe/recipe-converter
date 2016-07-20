part of parser;

List<Recipe> getReplacements(List<IngredientPart> parts, String type) {
  List<Recipe> replacements = new List<Recipe>();
  List<IngredientPart> foodstuff =
  parts.where((p) => p.type == IngredientPartType.foodstuff);

  foodstuff.forEach((food) {
    config["replacements"][type].forEach((replacement) {
      replacement["keys"].forEach((String key) {
        String foodText = " " + food.text + " ";
        String keyWord = " " + key + " ";
        if (foodText.contains(keyWord)) {
          bool alreadyContainsReplacement = false;

          // Make sure that the original food text does not already
          // contain one of the replacements, for example:
          // "0.5 dl smör, eller magarin" already contains smör
          replacement["values"].forEach((value) {
            foodstuff.forEach((part) {
              if (part.text.contains(value["title"])) {
                alreadyContainsReplacement = true;
              }
            });
          });

          if (!alreadyContainsReplacement) {
            replacement["values"].forEach((value) {
              Recipe replacementRecipe = new Recipe();
              replacementRecipe.title = value["title"];
              List<Ingredient> replacementIngredients =
              new List<Ingredient>();

              value["ingredients"].forEach((String ingredientText) {
                Ingredient ingredient = new Ingredient(null, ingredientText);
                ingredient.parts = getIngredientParts(ingredient);
                replacementIngredients.add(ingredient);
              });

              RecipePart recipePart =
              new RecipePart("Ingredienser", replacementIngredients);
              replacementRecipe.recipeParts.add(recipePart);

              replacements.add(replacementRecipe);
            });
          }
        }
      });
    });
  });

  return replacements;
}