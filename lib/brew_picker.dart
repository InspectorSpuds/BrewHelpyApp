import 'package:brewhelpy/recipe_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrewPicker extends StatelessWidget {
  const BrewPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Pick your brew method!",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontFamily: "OpenSans")),
        StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('BrewMethod').snapshots(),
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
                    var data = snapshot.data?.docs[index];

                    final String assetName = data?['file'];
                    final String brewMethod = data?['name'];

                    return GestureDetector(
                      onTap: () {
                        // navigate to the brew picker page for all recipes of given type
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePicker(brewMethod: brewMethod)),);

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
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Image(image: AssetImage(assetName))),
                            Text(brewMethod,
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
    );
  }
}
