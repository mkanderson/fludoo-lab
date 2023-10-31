import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:odoorpcscratch/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final odooClientProvider = FutureProvider((ref) async {
  final prefs = await SharedPreferences.getInstance();

  // Restore session if it was stored in shared prefs
  final sessionString = prefs.getString(cacheSessionKey);
  OdooSession? session = sessionString == null
      ? null
      : OdooSession.fromJson(json.decode(sessionString));
  final orpc = OdooClient(databaseURL, session);

  // Bind session change listener to store recent session
  final sessionChangedHandler = storeSesion(prefs);
  orpc.sessionStream.listen(sessionChangedHandler);

  /// Here restored session may already be expired.
  /// We will know it on any RPC call getting [OdooSessionExpiredException] exception.
  ///

  if (sessionString == null) {
    await orpc.authenticate(databaseName, login, password);
  } else {}

  return orpc;
});
