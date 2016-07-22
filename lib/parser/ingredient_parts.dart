part of parser;

List<IngredientPart> getIngredientParts(Ingredient ingredient) {
  List<IngredientPart> ingredientParts = new List<IngredientPart>();

  ingredientParts.addAll(getMeasurementParts(ingredient));
  ingredientParts.addAll(getTypeParts(ingredient));

  List<IngredientPart> foodstuff = getFoodstuffParts(ingredient.text, ingredientParts);
  ingredientParts.addAll(foodstuff);

  return ingredientParts;
}

Future addNutrition(DabasService dabasService, List<Ingredient> ingredients) async {
  List<String> texts = new List<String>();

  ingredients.forEach((Ingredient ingredient) {
    List<IngredientPart> foodstuff =
    ingredient.parts.where((p) => p.type == IngredientPartType.foodstuff);

    foodstuff.forEach((foodstuff) {
      texts.add(foodstuff.text);
    });
  });

  return await dabasService.addNutritionToFoodstuff(texts);
}

List<IngredientPart> getFoodstuffParts(
    String ingredientText, List<IngredientPart> parts) {
  List<IngredientPart> foodstuff = new List<IngredientPart>();

  // Sorts the parts so that numerical values comes last
  // If not, a 2 would first replace the 2 in "125 g" which would then
  // become 15 g and thus, not be found when it's time to replace that part
  parts.sort((a, b) => isNumeric(a.text).compareTo(isNumeric(b.text)));

  parts.forEach((part) {
    ingredientText = ingredientText.toLowerCase().replaceAll(part.text, "");
    ingredientText = ingredientText.replaceAll("eller liknande", "");
    ingredientText = ingredientText.replaceAll("eller mer", "");
  });

  List<String> foodstuffParts = new List<String>();
  List<String> strings = ["och", "eller", "/"];

  if (ingredientText.contains(new RegExp(r"(" + strings.join('|') + ")"))) {
    strings.forEach((splitString) {
      if (ingredientText.contains(splitString)) {
        List<String> splitParts = ingredientText.split(splitString);

        splitParts.forEach((splitPart) {
          splitPart = splitPart.trim();
          if (splitPart.isNotEmpty) {
            foodstuffParts.add(splitPart);
          }
        });

        ingredientText = ingredientText.replaceAll(splitString, "");
      }
    });
  } else {
    foodstuffParts.add(ingredientText);
  }

  foodstuffParts.forEach((food) {
    // leading + trailing "," "()", ",,", ", ," and "  "
    String text =
    food.replaceAll(new RegExp(r"(^,)|(\(\))|,,|, ,|,|(,$)"), "");
    text = text.replaceAll(new RegExp(r'(\((or|ar)\))'), ' ');
    text = text.replaceAll(new RegExp(r'\s+'), ' ').trim();

    foodstuff.add(new IngredientPart(IngredientPartType.foodstuff, text));
  });

  return foodstuff;
}

List<IngredientPart> getTypeParts(Ingredient ingredient) {
  List<IngredientPart> measurements = new List<IngredientPart>();
  String regex = r"(";
  config["types"].forEach((text) => regex += "\\b" + text["sv"] + "\\b|");
  regex = regex.substring(0, regex.length - 1);
  regex += ")";

  RegExp regexp = new RegExp(regex);
  Iterable<Match> matches = regexp.allMatches(ingredient.text.toLowerCase());

  matches.forEach((match) {
    measurements
        .add(new IngredientPart(IngredientPartType.type, match.group(0)));
  });

  return measurements;
}

List<IngredientPart> getMeasurementParts(Ingredient ingredient) {
  ingredient.text = ingredient.text.replaceAll("1/2", "½");
  ingredient.text = ingredient.text.replaceAll("3/4", "¾");
  ingredient.text = ingredient.text.replaceAll("- ", "-");

  List<IngredientPart> measurements = new List<IngredientPart>();

  String regex = r"((ev\.\s|ca\s|à\s)*[\d\½\¾]+[\,\-\.]*[\d\½\¾]*)";
  regex += "(";
  config["measurements"].forEach((text) {
    regex += " " + text["sv"];

    // If the ingredient contains å,ä or ö we cant use \b
    // Using \b would match "gr" in "grönsaksbuljong"
    regex += (ingredient.text.contains(new RegExp(r"å|ä|ö")))
        ? "(?![a-zA-åäöÅÄÖ])|"
        : "\\b|";
  });
  regex = regex.substring(0, regex.length - 1);
  regex += ")*";

  RegExp regexp = new RegExp(regex);
  Iterable<Match> matches = regexp.allMatches(ingredient.text.toLowerCase());

  matches.forEach((match) {
    measurements.add(
        new IngredientPart(IngredientPartType.measurement, match.group(0)));
  });

  return measurements;
}