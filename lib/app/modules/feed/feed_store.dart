import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStoreBase with _$FeedStore;
abstract class _FeedStoreBase with Store {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;

  _FeedStoreBase({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage
  }) {
    _loadFeed();
    firebaseAuth.userChanges().listen(_onUserChange);
  }

  @observable
  bool loading = false;

  @observable
  User? user;

  @observable
  Stream<QuerySnapshot> posts = Stream.empty();

  @action
  Future<void> _loadFeed() async {
    final user = await firebaseFirestore.doc('user/${firebaseAuth.currentUser!.uid}').get();
    final following = user.data()!['following'];

    posts = firebaseFirestore.collection('post')
        .where('userId', whereIn: following)
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return firebaseFirestore.doc('user/$userId').get();
  }

  @action
  void _onUserChange(User? user) {
    if(user?.isAnonymous ?? true) {
      this.user = null;
    }else {
      this.user = user;
    }
  }

  @action
  Future<void> postPicture(String filePath) async {
    loading = true;

    final file = File(filePath);
    final task = await firebaseStorage.ref('${user!.uid}/post_${DateTime.now().millisecondsSinceEpoch}').putFile(file);
    final url = await task.ref.getDownloadURL();

    firebaseFirestore.collection('post').add({
      'userId': user!.uid,
      'dateTime': DateTime.now().toIso8601String(),
      'url': url
    });

    loading = false;
  }

  @action
  Future<void> logoff() async {
    await firebaseAuth.signOut();
  }
}