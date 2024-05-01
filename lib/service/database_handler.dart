//Author: Ishan Parikh
//Date: 4-29-24
//Purpose: the firebase database handler for the brewhelpy app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


class DbHandler {
  late var _db;
  DBHandler(){}

  Future<void> init() async  {
    _db = FirebaseFirestore.instance;
  }

  /*creates a recipe, format:
    brewMethod: {
      units: str,
      value: int,
    },
    coffeeMass: int,
    name: str,
    totalTime: str,
    userId: str (nullable for now, will require as login is integrated)
   */
  Future<DocumentSnapshot<Object?>> addRecipe(Map<String, dynamic> recipe) async {
    return _db.collection('Recipes').add(recipe);
  }

  Stream<QuerySnapshot> getRecipes()  {
    return _db.collection('Recipes').get();
  }

}