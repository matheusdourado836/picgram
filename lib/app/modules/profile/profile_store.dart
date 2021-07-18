import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;
abstract class _ProfileStoreBase with Store {

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFireStore;
  FirebaseStorage firebaseStorage;

  _ProfileStoreBase({
    required this.firebaseAuth,
    required this.firebaseFireStore,
    required this.firebaseStorage
}) {
    firebaseAuth.userChanges().listen(_onUserChange);
  }

  @observable
  late User? user = firebaseAuth.currentUser;

  @observable
  int? followers;

  @observable
  int? following;

  @observable
  String? bio;

  @observable
  String? userName;

  @observable
  bool loading = false;

  @observable
  FirebaseException? error;

  @action
  void _onUserChange(User? user) {
    this.user = user;
    if(user != null) {
      firebaseFireStore.doc('user/${user.uid}').snapshots().listen(_listenUser);
    }
  }

  @action
  void _listenUser(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if(snapshot.exists) {
      final data = snapshot.data() ?? {};
      userName = data['userName'] as String;
      bio = data['bio'] as String;
      followers = data.containsKey('followers') ? data['followers'].length : 0;
      following = data.containsKey('following') ? data['following'].length : 0;
    }
  }

  @action
  Future<void> updateProfile({required String displayName, required String bio, required String userName}) async {
    if (user == null) {
      return;
    }
    try {
      loading = true;

      await firebaseFireStore.doc('user/${user!.uid}').set({
        'displayName': displayName,
        'userName': userName,
        'bio': bio
      }, SetOptions(merge: true));

      await firebaseAuth.currentUser!.updateDisplayName(displayName);
    }on FirebaseException catch(e) {
      error = e;
    }finally {
      loading = false;
    }
  }

  @action
  Future<void> updateProfilePicture(String filePath) async {
    loading = true;

    final userRef = await firebaseFireStore.doc('user/${user!.uid}');

    final file = File(filePath);
    final task = await firebaseStorage.ref('${user!.uid}/profilePicture.jpg').putFile(file);
    final url = await task.ref.getDownloadURL();

    firebaseAuth.currentUser!.updatePhotoURL(url);

    await userRef.set({
      'profilePicture': url
    }, SetOptions(merge: true));

    loading = false;
  }

  @action
  Future<void> deletePost(String postId, String postUrl) async {
     firebaseFireStore.collection('post').doc(postId).delete();
     firebaseStorage.refFromURL(postUrl).delete();
  }

  @computed
  Stream<QuerySnapshot> get posts {
    return firebaseFireStore.collection('post')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  @action
  Future<void> logoff() async {
    await firebaseAuth.signOut();
  }

  @action
  Future<void> postPicture(String filePath) async {
    loading = true;

    final postId = Random.secure().nextInt(100);
    final file = File(filePath);
    final task = await firebaseStorage.ref('${user!.uid}/post_${DateTime.now().millisecondsSinceEpoch}').putFile(file);
    final url = await task.ref.getDownloadURL();

    firebaseFireStore.collection('post').doc(postId.toString()).set({
      'postId': postId,
      'userId': user!.uid,
      'dateTime': DateTime.now().toIso8601String(),
      'url': url
    });

    loading = false;
  }
}