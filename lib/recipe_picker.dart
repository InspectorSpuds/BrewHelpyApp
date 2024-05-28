 import 'package:brewhelpy/models/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class RecipePicker extends StatefulWidget {
  final String brewMethod;

  const RecipePicker({super.key, required this.brewMethod });

  @override
  State<StatefulWidget> createState() => RecipePickerState();

}

class RecipePickerState extends State<RecipePicker> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetails>(
        builder:(context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text("Pick a recipe"),
            ),
            body: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Recipes').where('brewMethod', isEqualTo: widget.brewMethod).snapshots(),
                    builder: (BuildContext context, var snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (!snapshot.hasData) return const Text('no data');

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data?.size,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Object?>? data = snapshot.data?.docs[index];

                            final String recipeKey = data?.id ?? "";

                            return GestureDetector(
                              onTap: () {
                                // navigate to the brew picker page for all recipes of given type

                                //pop the recipe viewer then go to the brew timer page
                                Navigator.pop(context);

                                // update recipe id adn then navigate
                                provider.updateRecipe(recipeKey);
                                provider.updatePage(2);
                              },
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //Center Row contents horizontally,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Text("sdf")),
                                    Text(data?['name'],
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).secondaryHeaderColor))
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ],
            ),
          );
        }
    );
  }
}