//Author: Ishan Parikh
//Date: 4-29-24
//Purpose: the firebase database handler for the brewhelpy app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../recipe.dart';


class DbHandler {
  late var _db;

  DBHandler(){}

  Future<void> test() async {
    _db = FakeFirebaseFirestore();
  }

  void init()  {
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

  Future<DocumentReference> addUser(String username, String password) async {
    return _db.collection('User').add({
      'email': username,
      'password': password,
    });
  }


  Future<DocumentReference> getRecipes()  {
    return _db.collection('Recipes').get();
  }

}