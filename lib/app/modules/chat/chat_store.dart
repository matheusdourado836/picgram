import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStoreBase with _$ChatStore;
abstract class _ChatStoreBase with Store {

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  _ChatStoreBase({
    required this.firebaseAuth,
    required this.firebaseFirestore
  });

  @observable
  bool loading = false;

  @observable
  late User? user = firebaseAuth.currentUser;

  @observable
  Stream<QuerySnapshot> searchResult = Stream.empty();

  @action
  Future<void> search(String query) async {
    if(query.isNotEmpty && query.length >= 3){
      searchResult = firebaseFirestore.collection('user')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isNotEqualTo: firebaseAuth.currentUser!.displayName)
          .snapshots();
    }else {
      searchResult = Stream.empty();
    }
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return firebaseFirestore.doc('user/$userId').get();
  }


  @computed
  Stream<QuerySnapshot> get loadMessages {
    return firebaseFirestore.collection('user').doc(user!.uid).collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @computed
  Stream<QuerySnapshot> get carregarChats {
    return firebaseFirestore.collection('user').doc(user!.uid).collection('chats')
        .snapshots();
  }

  @action
  Future<void> adicionarChat(Map<String, dynamic> userReceived) async {
    final addingChat = firebaseFirestore
        .collection('user')
        .doc(userReceived['userId'])
        .collection('chats')
        .doc(userReceived['userId']);

    addingChat.set({
      'userId': user!.uid,
      'profilePicture': user!.photoURL,
      'displayName': user!.displayName,
    }, SetOptions(merge: true));

    final addedChat = firebaseFirestore.collection('user').doc(user!.uid).collection('chats').doc(userReceived['userId']);

    addedChat.set({
      'userId': userReceived['userId'],
      'profilePicture': userReceived['profilePicture'],
      'displayName': userReceived['displayName']
    }, SetOptions(merge: true));
  }

  @action
  Future<void> sendMsg(Map<String, dynamic> userRceived, String message) async {
      final sendingMsg = firebaseFirestore.doc('user/${userRceived['userId']}').collection('messages');

      sendingMsg.add({
        'createdAt': DateTime.now(),
        'userId': user!.uid,
        'toUser': userRceived['displayName'],
        'fromUser': user!.displayName,
        'profilePicture': user!.photoURL,
        'message': message
      });

      final sentMsg = firebaseFirestore.doc('user/${user!.uid}').collection('messages');

      sentMsg.add({
        'createdAt': DateTime.now(),
        'userId': user!.uid,
        'toUser': userRceived['displayName'],
        'fromUser': user!.displayName,
        'profilePicture': user!.photoURL,
        'message': message
      });
  }
}