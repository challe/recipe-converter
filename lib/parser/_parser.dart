part of parser;

class Parser {
  DabasService _dabasService;

  Parser(this._dabasService);

  Future<Recipe> parseString(String input, String type) async {
    Recipe recipe = new Recipe();
    recipe.title = "Eget inskrivna ingredienser";
    List<String> inputRows = input.split("\n");
    List<Ingredient> ingredients = new List<Ingredient>();

    inputRows.forEach((row) {
      ingredients.add(new Ingredient(null, row));
    });

    recipe.recipeParts.add(new RecipePart("Ingredienser", ingredients));
    addPartsAndReplacements(recipe, type);

    return recipe;
  }

  void addPartsAndReplacements(Recipe recipe, String type) {
    recipe.recipeParts.forEach((recipePart) {
      recipePart.ingredients.forEach((ingredient) {
        ingredient.parts = getIngredientParts(ingredient);
        ingredient.replacements = getReplacements(ingredient.parts, type);
      });

      //addNutrition(_dabasService, recipePart.ingredients);
    });
  }

  Future<Recipe> parseHTML(Recipe recipe, String type) async {
    DomParser domParser = new DomParser();
    if (recipe.html == "") return recipe;

    recipe.document = domParser.parseFromString(recipe.html, "text/html");
    recipe.title = recipe.document.querySelector("title").text;
    recipe.amount = getAmount(recipe.document)["amount"];

    List<Element> ingredientElements = getIngredientElements(recipe);

    if (ingredientElements.length > 0) {
      List<Ingredient> ingredients = getIngredients(ingredientElements);
      recipe.recipeParts = getRecipeParts(ingredients);
      addPartsAndReplacements(recipe, type);
    }

    return recipe;
  }
}
