part of parser;

List<Ingredient> getIngredients(List<Element> ingredientElements) {
  List<Ingredient> ingredients = new List<Ingredient>();
  ingredientElements.forEach((element) {
    String ingredientText = getIngredientText(element);
    Ingredient ingredient = new Ingredient(element, ingredientText);
    ingredient.groupName = getGroupName(element);

    ingredients.add(ingredient);
  });

  return ingredients;
}

String getIngredientText(Element element) {
  String text = element.text;

  if (element.children.length > 0) {
    Element tmp = element.clone(true);
    tmp.children = tmp.children.toList();

    if (tmp.children.length > 0) {
      for (int i = tmp.children.length - 1; i >= 0; i--) {
        Element child = tmp.children[i];
        if (isHidden(child)) {
          tmp.children.remove(child);
        }
      }
    }

    tmp.nodes.forEach((node) {
      node.text = " " + node.text + " ";
    });
  }

  text = text.replaceAll(new RegExp(r'\s+'), ' ').trim();

  return text;
}

String getGroupName(Element element) {
  String groupName = "";
  Element closest = findClosestParent(element, "ul");

  Element header = null;
  if (closest != null) {
    header = closest.previousElementSibling;

    if (getAmount(header)["contains"]) {
      header = header.previousElementSibling;
    }
  }

  if (header != null) {
    groupName = header.text.replaceAll(":", "").trim();
  }

  groupName = (groupName.isEmpty) ? "Ingredienser" : groupName;

  return groupName;
}