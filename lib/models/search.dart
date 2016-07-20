part of models;

class Search {
  List<String> types;
  List<Recipe> recipes = new List<Recipe>();
  String currentUrl = "";
  bool debug = false;
  bool fetching = false;
  bool testing = false;
  String type;

  String header, convert, example, converted, placeholder, howDoesItWork;
  String parseError;
}
