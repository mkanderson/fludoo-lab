import 'package:odoo_rpc/odoo_rpc.dart';

class OdooInstance {
  OdooInstance(
      {required this.name,
      required this.url,
      required this.login,
      required this.dbname});
  final String name;
  final String url;
  final String login;
  final String dbname;
  OdooSession? session;
}
