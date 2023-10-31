import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _databaseController = TextEditingController();

  // Create storage
  final _storage = const FlutterSecureStorage();

  void _testConnection() async {
    if (_formKey.currentState!.validate()) {
      // Get the values from the controllers
      String username = _usernameController.text;
      String password = _passwordController.text;
      String url = _urlController.text;
      String database = _databaseController.text;

      // Create an Odoo client instance
      final client = OdooClient(url);

      try {
        // Try to authenticate with the provided credentials
        await client.authenticate(database, username, password);

        // If successful, store the credentials and URL securely
        await _storage.write(key: 'username', value: username);
        await _storage.write(key: 'password', value: password);
        await _storage.write(key: 'url', value: url);
        await _storage.write(key: 'database', value: database);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green.withOpacity(0.8),
            content: const Text(
              "Success!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )));

        // Navigate to the main screen or show a success message
        // ...
      } catch (e) {
        // If the authentication fails, show an error message
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Odoo'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'Server URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the server URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _databaseController,
                decoration: const InputDecoration(labelText: 'Database'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the database name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _testConnection,
                child: const Text('Test Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
