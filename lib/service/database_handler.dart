//Author: Ishan Parikh
//Date: 4-29-24
//Purpose: the firebase database handler for the brewhelpy app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:brewhelpy/recipe_steps.dart';
import 'package:firebase_core/firebase_core.dart';
import '../recipe.dart';
import 'firebase_options.dart';


class DbHandler {
  late var _db;
  DBHandler(){}

  Future<void> test() async {
    _db = FakeFirebaseFirestore();
  }

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
  Future<DocumentReference> addRecipe(Recipe newRecipe) async {
    return _db.collection('Recipes').add({
    'brewMethod': {
    'units': 'Celsius',
    'value': newRecipe.brewMethod,
    'brewTemp':newRecipe.brewTemp,
    },
    'coffeeMass': newRecipe.coffeeMass,
    'name': newRecipe.name,
    'totalTime': "$newRecipe.totalTime",
    'userID':
    "null", //for now we're keeping it null till we connect our login form
    'steps': newRecipe.steps.map((step) => {
    'waterWeight': step.waterWeight,
    'timestamp': step.timestamp,
    }).toList(),
  });
  }

  Stream<QuerySnapshot> getRecipes()  {
    return _db.collection('Recipes').get();
  }

}