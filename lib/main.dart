//Author: ishan parikh
import 'package:brewhelpy/brew_timer.dart';
import 'package:brewhelpy/login.dart';
import 'package:brewhelpy/models/app_state.dart';
import 'package:brewhelpy/modify_recipe_form.dart';
import 'package:brewhelpy/new_recipe_form.dart';
import 'package:brewhelpy/service/database_handler.dart';
import 'package:brewhelpy/service/firebase_options.dart';
import 'package:brewhelpy/service/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'brew_picker.dart';

void main() async {
  // Connect to firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize DB
  DbHandler handler = DbHandler();
  handler.init();

  // Create application providers
  runApp(ChangeNotifierProvider<AppDetails> (
    create: (_) => AppDetails(),
    child: MyApp(handler, ),
  ));
}

class MyApp extends StatelessWidget {
  final DbHandler _handler;
  const MyApp(this._handler, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHelpy',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color.fromRGBO(112, 84, 58, 1.0),
            secondary: Color.fromRGBO(245, 245, 220, 1.0),
          ),
          useMaterial3: true,

          // Text theme
          textTheme: const TextTheme()),
      themeMode: ThemeMode.dark,
      home: MyHomePage(_handler,  title: 'BrewHelpy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DbHandler _handler;

  MyHomePage(this._handler,{super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget _showNewRecipeForm() {
    setState(() {
      showDialog(
          context: context,
          builder: (context) => Dialog.fullscreen(
                child: NewRecipeForm(widget._handler),
              ));
    });

    return NewRecipeForm(widget._handler);
  }

  List<Widget> pages = [
    const BrewPicker(),
    NewRecipeForm(DbHandler()),
    BrewTimer(),
    const LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetails>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(widget.title),
          ),
          body: Center(
            child: pages.elementAt(provider.currPage),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Theme.of(context).primaryColor,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Theme.of(context).primaryColor,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(bodySmall: const TextStyle(color: Colors.yellow))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.coffee_maker_rounded),
                  label: 'Find',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), label: 'Create Recipe'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.punch_clock_outlined),
                  label: 'Brew timer',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: 'User',
                ),
              ],
              currentIndex: provider.currPage,
              selectedItemColor: Theme.of(context).secondaryHeaderColor,
              // currentIndex: _selectedIndex,
              onTap: (index) {
                provider.updatePage(index);
              },
            ),
          ),
        );
      }
    );
  }
}
