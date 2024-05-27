// Author: Eugene Keehan

import 'package:brewhelpy/service/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final DbHandler _handler = DbHandler();

  void _login()  {
    bool loginWasSuccessful = false;

    //try to make a login attetmpt with firebase
    try {
      _auth.signInWithEmailAndPassword(email: _usernameController.text, password: _passwordController.text)
          .then((cred) {
        print("Success: ${_auth.currentUser?.uid}");
        loginWasSuccessful = true;
        setState(() {});
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging in, try again later')),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged in')),
    );

  }

  void _navigateToCreateUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserForm()), // Removed const
    );
  }

  void _logout() {
    try {
      _auth.signOut().then((context) {setState((){});});
    } on FirebaseAuthException catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out')),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged out user')),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: (_auth.currentUser?.uid == null) ?
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Log In'),
                ),
                ElevatedButton(
                  onPressed: _navigateToCreateUser,
                  child: const Text('Create User'),
                ),
              ],
            ),
          ],
        ),
      ) :
      Center(
       child: Column(
         children: [
           ElevatedButton(
               onPressed: _logout,
               child: const Text("Logout"),
           )
         ],
       )
      )
    );
  }
}

class CreateUserForm extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CreateUserForm({super.key});

  @override
  _CreateUserFormState createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _newUsernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final DbHandler _handler = DbHandler();

  @override
  void initState() {
    super.initState();
    _handler.init();
  }
  void _createUser() async {
    try {
      widget._auth.createUserWithEmailAndPassword(email: _newUsernameController.text, password: _newPasswordController.text);
      // Navigate to the home screen or show a success message
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Failed to create user: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user: ${e.message}')),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully created user')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _newUsernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}