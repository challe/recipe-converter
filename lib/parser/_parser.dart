part of parser;
// https://pub.dartlang.org/packages/grinder

class Parser {
  static Future<Recipe> parseString(String input, String type) async {
    Recipe recipe = new Recipe();
    recipe.title = "Eget inskrivna ingredienser";
    List<String> inputRows = input.split("\n");
    List<Ingredient> ingredients = new List<Ingredient>();

    inputRows.forEach((row) {
      ingredients.add(new Ingredient(null, row));
    });

    recipe.recipeParts.add(new RecipePart("Ingredienser", ingredients));

    recipe.recipeParts.forEach((recipePart) {
      recipePart.ingredients.forEach((ingredient) {
        ingredient.parts = getIngredientParts(ingredient);
        ingredient.replacements = getReplacements(ingredient.parts, type);
      });
    });

    return recipe;
  }

  static Future<Recipe> parseHTML(Recipe recipe, String type) async {
    if (recipe.html == "") return recipe;

    DomParser domParser = new DomParser();
    recipe.document = domParser.parseFromString(recipe.html, "text/html");
    recipe.title = recipe.document.querySelector("title").text;

    recipe.amount = getAmount(recipe.document)["amount"];

    List<Element> ingredientElements = getIngredientElements(recipe);

    if (ingredientElements.length > 0) {
      List<Ingredient> ingredients = getIngredients(ingredientElements);
      recipe.recipeParts = getRecipeParts(ingredients);

      recipe.recipeParts.forEach((recipePart) {
        recipePart.ingredients.forEach((ingredient) {
          ingredient.parts = getIngredientParts(ingredient);
          ingredient.replacements = getReplacements(ingredient.parts, type);
        });
      });
    }

    return recipe;
  }

  // TODO: Ta fram tillagningsprocess

  static List<RecipePart> getRecipeParts(List<Ingredient> ingredients) {
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

  static List<String> getConversionTypes() {
    List<String> conversionTypes = new List<String>();
    config["replacements"].keys.forEach((replacement) {
      conversionTypes.add(replacement);
    });
    return conversionTypes;
  }

  static List<Recipe> getReplacements(List<IngredientPart> parts, String type) {
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

  static List<Ingredient> getIngredients(List<Element> ingredientElements) {
    List<Ingredient> ingredients = new List<Ingredient>();
    ingredientElements.forEach((element) {
      String ingredientText = getIngredientText(element);
      Ingredient ingredient = new Ingredient(element, ingredientText);
      ingredient.groupName = getGroupName(element);

      ingredients.add(ingredient);
    });

    return ingredients;
  }

  static Map<String, dynamic> getAmount(dynamic container) {
    bool contains = false;
    Element found = null;
    Amount amount = null;
    String nr, type;

    if (container != null) {
      if (container is Document) {
        for (final selector in config["selectors"]["amount"]) {
          found = container.querySelector(selector);

          if (found != null) {
            break;
          }
        }
      } else {
        if (container.children.length == 0) {
          for (final selector in config["selectors"]["amount"]) {
            if (container.parent.querySelector(selector) == container) {
              found = container;
              break;
            }
          }
        } else {
          for (final String selector in config["selectors"]["amount"]) {
            found = container.querySelector(selector);
            if (found != null) {
              break;
            }
          }
        }
      }
    }

    if (found != null) {
      Match firstMatch = new RegExp(r"[0-9]+").firstMatch(found.text);

      if (firstMatch != null) {
        contains = true;

        nr = firstMatch.group(0);
        type = found.text.replaceAll(nr, "");
        type = type.replaceAll(new RegExp(r'\s+'), ' ').trim();
        amount = new Amount(int.parse(nr), type);
      }
    }

    Map<String, dynamic> results = {"contains": contains, "amount": amount};

    return results;
  }

  static String getGroupName(Element element) {
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

  static List<Element> getIngredientElements(Recipe recipe) {
    List<Element> elements = new List<Element>();
    elements = getIngredientElementsFromItemProp(recipe);
    recipe.findMethod = "itemprop";

    if (elements.length == 0) {
      elements = getIngredientElementsFromContainers(recipe);
      recipe.findMethod = "containers";
    }

    if (elements.length == 0) {
      elements = getIngredientElementsByText(recipe);
      recipe.findMethod = "text";
    }

    if (elements.length == 0) {
      recipe.findMethod == "";
    }

    return elements;
  }

  static bool containsMeasurement(String text) {
    bool containsMeasurement = false;
    List<String> measurements = ConfigFunctions.getMeasurements();

    text = " " + text.toLowerCase() + " ";

    for (String measurement in measurements) {
      if (text.contains(" " + measurement + " ")) {
        containsMeasurement = true;
        break;
      }
    }

    return containsMeasurement;
  }

  static Element findClosestParent(Element element, String ancestorTagName) {
    Element parent = element.parent;

    while (parent.tagName.toLowerCase() != ancestorTagName.toLowerCase()) {
      parent = parent.parent;
      if (parent == null) {
        return null;
      }
    }
    return parent;
  }

  // TODO: Make it handle http://www.jennysmatblogg.nu/2014/03/24/pasta-carbonara-2/
  static List<Element> getIngredientElementsByText(Recipe recipe) {
    List<Element> ingredientElements = new List<Element>();

    List<Element> parentContainers = new List<Element>();
    Element parent = null;
    List<Element> listElements = recipe.document.querySelectorAll("li");
    for (Element listElement in listElements) {
      if (containsMeasurement(listElement.text)) {
        parent = findClosestParent(listElement, "ul");

        if (parent != null && !parentContainers.contains(parent)) {
          parentContainers.add(parent);
        }
      }
    }

    parentContainers.forEach((container) {
      container.children.forEach((ingredientElement) {
        ingredientElements.add(ingredientElement);
      });
    });

    return ingredientElements;
  }

  static List<Element> getIngredientElementsFromItemProp(Recipe recipe) {
    List<Element> ingredientElements = new List<Element>();

    for (final selector in config["selectors"]["itemProps"]) {
      if (ingredientElements.length > 0) break;

      List<Element> foundElements = recipe.document.querySelectorAll(selector);
      foundElements = foundElements.toList();

      // Make sure that the found elements are not hidden
      for (int i = foundElements.length - 1; i >= 0; i--) {
        Element foundElement = foundElements[i];
        if (isHidden(foundElement)) {
          foundElements.remove(foundElement);
        }
      }

      if (foundElements.length > 0) {
        ingredientElements = validateFoundElements(foundElements);
      }
    }

    return ingredientElements;
  }

  static bool isHidden(Element element) {
    bool isHidden = false;

    if (element.attributes.containsKey("style")) {
      if (element.attributes["style"].contains("display:none") ||
          element.attributes["style"].contains("display: none")) {
        isHidden = true;
      }
    } else if (element.attributes.containsKey("class")) {
      if (element.attributes["class"].contains("hidden")) {
        isHidden = true;
      }
    }

    return isHidden;
  }

  /* Takes a list of ingredient elements, and returns its parent <li>
     if no units were found. itemprop="ingredients" could for example
     return "lasagneplattor" instead of "ca 400 g lasagneplattor" if the
     element looks like this:
      <li>
        <span class="ingredient">ca 400 g</span>
        <span itemprop="ingredients">lasagneplattor</span>
      </li>
  */
  static List<Element> validateFoundElements(List<Element> found) {
    List<Element> ingredientElements = new List<Element>();

    // Check if the element we found is the complete ingredient element
    bool elementsContainsUnits = false;
    int nrOfElementsContainingMeasurements = 0;
    found.forEach((element) {
      if (containsMeasurement(element.text)) {
        nrOfElementsContainingMeasurements++;
      }
    });

    // If one third of the elements contains measurements, they're probably OK
    if(nrOfElementsContainingMeasurements > found.length/3) {
      elementsContainsUnits = true;
    }

    // The elements we found are probably not the complete ingredients
    window.console.log("elementsContainsUnits");
    window.console.log(elementsContainsUnits);

    if (!elementsContainsUnits) {
      found.forEach((element) {
        bool found = false;
        ["li", "tr"].forEach((selector) {
          Element ingredientElement = findClosestParent(element, selector);
          if (ingredientElement != null && ingredientElement.text.isNotEmpty && found == false) {
            ingredientElements.add(ingredientElement);
            found = true;
          }
        });

      });
    }
    // The element we found is the already a complete ingredient including units
    // Just make sure its not empty
    else {
      found.forEach((ingredientElement) {
        if (ingredientElement.text.isNotEmpty) {
          ingredientElements.add(ingredientElement);
        }
      });
    }

    return ingredientElements;
  }

  static List<Element> getIngredientElementsFromContainers(Recipe recipe) {
    List<Element> ingredientElements = new List<Element>();

    for (final selector in config["selectors"]["containers"]) {
      List<Element> containers = recipe.document.querySelectorAll(selector);

      if (ingredientElements.length > 0) break;

      containers.forEach((container) {
        container.children.forEach((element) {
          if (!isHidden(element) && element.text.isNotEmpty) {
            ingredientElements.add(element);
          }
        });
      });
    }

    return ingredientElements;
  }

  static String getIngredientText(Element element) {
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

  static List<IngredientPart> getIngredientParts(Ingredient ingredient) {
    List<IngredientPart> ingredientParts = new List<IngredientPart>();
    ingredientParts.addAll(getMeasurements(ingredient));
    ingredientParts.addAll(getTypes(ingredient));

    ingredientParts.addAll(getFoodstuff(ingredient.text, ingredientParts));

    return ingredientParts;
  }

  static int isNumeric(String s) {
    if (s == null) {
      return 0;
    }
    return (double.parse(s, (e) => null) != null) ? 1 : 0;
  }

  static List<IngredientPart> getFoodstuff(
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
      text = text.replaceAll(new RegExp(r'\s+'), ' ');

      foodstuff.add(new IngredientPart(IngredientPartType.foodstuff, text));
    });

    return foodstuff;
  }

  static List<IngredientPart> getTypes(Ingredient ingredient) {
    List<IngredientPart> measurements = new List<IngredientPart>();
    String regex = r"(";
    config["types"].forEach((text) => regex += "\\b" + text["se"] + "\\b|");
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

  static List<IngredientPart> getMeasurements(Ingredient ingredient) {
    ingredient.text = ingredient.text.replaceAll("1/2", "½");
    ingredient.text = ingredient.text.replaceAll("3/4", "¾");
    ingredient.text = ingredient.text.replaceAll("- ", "-");

    List<IngredientPart> measurements = new List<IngredientPart>();
    String regex = r"((ev\.\s|ca\s|à\s)*[\d\½\¾][\,\-\.]*[\d\½\¾]*)";
    regex += "(";
    config["measurements"].forEach((text) {
      regex += " " + text["se"];

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
}
