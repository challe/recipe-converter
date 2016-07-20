part of parser;

List<RecipePart> getRecipeParts(List<Ingredient> ingredients) {
  List<RecipePart> recipeParts = new List<RecipePart>();

  bool containsParts = false;
  ingredients.forEach((ingredient) {
    if (ingredient.groupName != "") {
      containsParts = true;
    }
  });

  if (containsParts) {
    ingredients.forEach((ingredient) {
      bool hasRecipePart = false;
      recipeParts.forEach((recipePart) {
        if (recipePart.name == ingredient.groupName) {
          hasRecipePart = true;
        }
      });

      if (!hasRecipePart) {
        List<Ingredient> ingredientsInGroup = new List<Ingredient>();
        ingredientsInGroup =
            ingredients.where((i) => i.groupName == ingredient.groupName);

        RecipePart recipePart =
        new RecipePart(ingredient.groupName, ingredientsInGroup);
        recipeParts.add(recipePart);
      }
    });
  } else {
    recipeParts.add(new RecipePart("Ingredienser", ingredients));
  }

  return recipeParts;
}