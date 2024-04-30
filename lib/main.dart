
import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/new_recipe_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHelpy',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BrewHelpy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = -1;

  void _showNewRecipeForm(){
    setState(() {
      showDialog(context: context,
          builder: (context) => const Dialog.fullscreen(
            child: NewRecipeForm(),
          ));
    });
  }

  void _modifyRecipeForm(){
    setState(() {
      showDialog(context: context,
          builder: (context) => const Dialog.fullscreen(
            child: ModifyRecipeForm(),
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
              onPressed: _modifyRecipeForm,
              icon: const Icon(Icons.edit))
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.coffee_maker),
              label: 'View Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Current Brews',
          ),
        ],
        // currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewRecipeForm,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
          ],
        )
      ),
    );
  }
}
