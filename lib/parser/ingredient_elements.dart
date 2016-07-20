part of parser;

List<Element> getIngredientElements(Recipe recipe) {
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

List<Element> getIngredientElementsFromItemProp(Recipe recipe) {
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

List<Element> getIngredientElementsFromContainers(Recipe recipe) {
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

// TODO: Make it handle http://www.jennysmatblogg.nu/2014/03/24/pasta-carbonara-2/
List<Element> getIngredientElementsByText(Recipe recipe) {
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

/* Takes a list of ingredient elements, and returns its parent <li> or <tr>
   if no units were found. itemprop="ingredients" could for example
   return "lasagneplattor" instead of "ca 400 g lasagneplattor" if the
   element looks like this:
    <li>
      <span class="ingredient">ca 400 g</span>
      <span itemprop="ingredients">lasagneplattor</span>
    </li>
*/
List<Element> validateFoundElements(List<Element> found) {
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
