import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/chat/chat_screen_page.dart';

import 'chat_page.dart';
import 'chat_store.dart';

class ChatModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ChatStore(
        firebaseFirestore: i.get<FirebaseFirestore>(),
        firebaseAuth: i.get<FirebaseAuth>(),)),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ChatPage()),
    ChildRoute(Constants.Routes.CHAT_SCREEN, child: (_, args) => ChatScreenPage(), transition: TransitionType.fadeIn),
  ];

}