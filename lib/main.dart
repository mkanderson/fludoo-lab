import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoorpcscratch/models/product_template.dart';
import 'package:odoorpcscratch/providers/product_provider.dart';
import 'package:odoorpcscratch/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/product_detail.dart';

const databaseURL = 
const databaseName = 
const login = 
const password = 

// key name must be unique per user/db pair.
const cacheSessionKey = 'odoo-session';

typedef SessionChangedCallback = void Function(OdooSession sessionId);

/// Callback for session changed events
SessionChangedCallback storeSesion(SharedPreferences prefs) {
  /// Define func that will be called on every session update.
  /// It receives configured [SharedPreferences] instance.
  void sessionChanged(OdooSession sessionId) {
    if (sessionId.id == '') {
      prefs.remove(cacheSessionKey);
    } else {
      prefs.setString(cacheSessionKey, json.encode(sessionId.toJson()));
    }
  }

  return sessionChanged;
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(observers: [Logger()], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo RPC Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  final showLogin = false;
  Widget ListItem(BuildContext context, ProductTemplate record) {
    //var unique = record['__last_update'] as String;
    //unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
    final ImageProvider avatarImage;
    if (record.image_512.toString() != 'false' && record.image_512 != null) {
      var imgMedium =
          base64Decode(record.image_512!.replaceAll(RegExp(r'\s+'), ''));
      avatarImage = Image.memory(imgMedium).image;
    } else {
      avatarImage = const AssetImage('assets/placeholder.png');
    }
    return Card(
      elevation: 8,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: avatarImage, radius: 20),
        title: Text(record.name),
        subtitle:
            Text(record.default_code is String ? record.default_code! : ''),
        onTap: () {
          // Navigate to the detail page when the list item is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(record: record),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productFetcher = ref.watch(productTemplateNotifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Icon(Icons.generating_tokens),
        ],
      ),
      body: showLogin
          ? const LoginScreen()
          : Center(
              child: productFetcher.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) {
                throw error;
              },
              data: (productData) => ListView.builder(
                itemCount: productData.length,
                itemBuilder: (context, index) {
                  final record = productData[index];
                  return ListItem(context, record);
                },
              ),
            )),
    );
  }
}
