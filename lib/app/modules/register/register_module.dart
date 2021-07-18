import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:picgram/app/modules/register/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RegisterStore(i.get<FirebaseAuth>(), i.get<SharedPreferences>(), i.get<FirebaseFirestore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => RegisterPage()),
  ];
}
