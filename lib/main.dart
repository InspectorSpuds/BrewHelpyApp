
import 'package:brewhelpy/brew_timer.dart';
import 'package:brewhelpy/login.dart';
import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/new_recipe_form.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:brewhelpy/service/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //connect to firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DbHandler handler = DbHandler();
  await handler.init();
  runApp(MyApp(handler));
}

class MyApp extends StatelessWidget {
  DbHandler _handler;

  MyApp(this._handler, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHelpy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(this._handler, title: 'BrewHelpy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  DbHandler _handler;

  MyHomePage(this._handler, {super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection('Recipe').snapshots(),
            builder: (BuildContext context, var snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data?.size,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index];
                      return Row(
                        children: [
                          Text("${data?['name']}"),
                          Text("dosage: ${data?['coffeeMass']}"),
                          Text(
                              "Temp: ${data?['brewMethod']['value']} ${data?['brewMethod']['units'] == "Celsius" ? "C" : "F"}"),
                          Text("Time: ${data?['totalTime']}"),
                          Spacer(),
                        ],
                      );
                    });
              }
            },
          ),
        ),
      ],
    ),
    BrewTimer(""),
    LoginScreen(),
  ];

  void _showNewRecipeForm() {
    setState(() {
      showDialog(
          context: context,
          builder: (context) => Dialog.fullscreen(
                child: NewRecipeForm(widget._handler),
              ));
    });
  }

  void _showModifyRecipeForm(){
    setState(() {
      showDialog(
          context: context,
          builder: (context) => Dialog.fullscreen(
            child: ModifyRecipeForm(widget._handler),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(widget.title),
      ),
      actions: [
        IconButton(
          onPressed: _showModifyRecipeForm,
          icon: const Icon(Icons.edit))
        ],
    ),
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee_maker),
              label: 'View Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Brew timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Login',
            ),
        
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          // currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: _showNewRecipeForm,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
            ],
          )),
    );
  }
}
