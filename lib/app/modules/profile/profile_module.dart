import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/profile/edit_page.dart';
import 'package:picgram/app/modules/profile/open_pub_page.dart';
import 'package:picgram/app/modules/profile/profile_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/profile/profile_page.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileStore(
        firebaseAuth: i.get<FirebaseAuth>(),
        firebaseStorage: i.get<FirebaseStorage>(),
        firebaseFireStore: i.get<FirebaseFirestore>()
    )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProfilePage()),
    ChildRoute(Constants.Routes.EDIT, child: (_, args) => EditPage(), transition: TransitionType.rightToLeftWithFade),
    ChildRoute(Constants.Routes.POSTS, child: (_, args) => OpenPubPage(), transition: TransitionType.rightToLeftWithFade)
  ];
}
