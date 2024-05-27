import 'package:flutter/material.dart';

class AppDetails extends ChangeNotifier {
  int currPage = 0;
  String recipeKey = "";

  void updatePage(int page) {
    currPage = page;
    notifyListeners();
  }
  void updateRecipe(String key) {
    recipeKey = key;
    notifyListeners();
  }
}