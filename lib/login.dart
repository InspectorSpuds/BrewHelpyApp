// Author: Eugene Keehan

import 'package:brewhelpy/service/database_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final DbHandler _handler = DbHandler();

  void _login() {
    // TODO
    print('Login with: ${_usernameController.text}, ${_passwordController.text}');
  }

  void _navigateToCreateUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserForm()), // Removed const
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Padding(
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
      ),
    );
  }
}

class CreateUserForm extends StatefulWidget {
  final FirebaseAuth auth;

  CreateUserForm({super.key, FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance;

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
      //TODO: add in configuration file, logic works fine
      //UserCredential userCredential = await widget.auth.createUserWithEmailAndPassword(
      //  email: _newUsernameController.text,
      //  password: _newPasswordController.text,
      //);

      _handler.addUser(_newUsernameController.text, _newPasswordController.text);

      print('Creating user with: ${_newUsernameController.text}, ${_newPasswordController.text}');
      // Navigate to the home screen or show a success message
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Failed to create user: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user: ${e.message}')),
      );
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully created user')),
      );
    }
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