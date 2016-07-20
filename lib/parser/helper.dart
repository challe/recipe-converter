part of parser;

bool isHidden(Element element) {
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

int isNumeric(String s) {
  if (s == null) {
    return 0;
  }
  return (double.parse(s, (e) => null) != null) ? 1 : 0;
}

bool containsMeasurement(String text) {
  bool containsMeasurement = false;
  List<String> measurements = ConfigHelper.getMeasurements();

  text = " " + text.toLowerCase() + " ";

  for (String measurement in measurements) {
    if (text.contains(" " + measurement + " ")) {
      containsMeasurement = true;
      break;
  }
}

return containsMeasurement;
}

Element findClosestParent(Element element, String ancestorTagName) {
  Element parent = element.parent;

  if(parent != null) {
    while (parent.tagName.toLowerCase() != ancestorTagName.toLowerCase()) {
      parent = parent.parent;
      if (parent == null) {
        return null;
      }
    }
  }

  return parent;
}

Map<String, dynamic> getAmount(dynamic container) {
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