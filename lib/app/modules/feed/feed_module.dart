import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/chat/chat_page.dart';
import 'package:picgram/app/modules/feed/feed_page.dart';

import '../../constants.dart';
import 'feed_store.dart';

class FeedModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => FeedStore(
        firebaseFirestore: i.get<FirebaseFirestore>(),
        firebaseAuth: i.get<FirebaseAuth>(),
        firebaseStorage: i.get<FirebaseStorage>())),
  ];


  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => FeedPage()),
    ChildRoute(Constants.Routes.CHAT, child: (_, args) => ChatPage(), transition: TransitionType.rightToLeftWithFade),
  ];

}