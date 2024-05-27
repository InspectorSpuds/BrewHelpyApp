//Author: Ishan Parikh
//Date: 4-29-24
//Purpose: the firebase database handler for the brewhelpy app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';


class DbHandler {
  late FirebaseFirestore _db;
  bool _isInitialized = false;

  DBHandler(){}

  Future<void> test() async {
    _db = FakeFirebaseFirestore();
  }

  void init()  {
    _db = FirebaseFirestore.instance;
    _isInitialized = true;
  }

  get isInitialized {
    return _isInitialized;
  }

  Future<DocumentReference> addRecipe(Recipe newRecipe) async {
    return _db.collection('Recipes').add({
      'temperature': {
        'units': 'Celsius',
        'brewTemp':newRecipe.brewTemp,
      },
      'brewMethod': newRecipe.brewMethod,
      'coffeeMass': newRecipe.coffeeMass,
      'name': newRecipe.name,
      'totalTime': "${newRecipe.totalTime}",
      'userId': FirebaseAuth.instance.currentUser?.uid ?? "null",
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


  Future<QuerySnapshot<Map<String, dynamic>>> getRecipes()  {
    return _db.collection('Recipes').get();
  }

}