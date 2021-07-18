import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:picgram/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStoreBase with _$RegisterStore;
abstract class _RegisterStoreBase with Store {

  SharedPreferences _sharedPreferences;

  FirebaseAuth _firebaseAuth;
  FirebaseFirestore _firebaseFirestore;
  _RegisterStoreBase(this._firebaseAuth, this._sharedPreferences, this._firebaseFirestore) {
    _firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  User? user;

  @observable
  bool loading = false;

  @action
  void _onAuthChange(User? user) {
    if(user?.isAnonymous ?? true) {
      this.user = null;
    }else {
      this.user = user;
    }
  }

  @action
  Future<void> registerUser({required String nome, required String email, required String password}) async {
    loading = true;
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(nome);
    final checkId = (await _firebaseFirestore.doc('user/${user!.uid}').get()).data() as Map<String, dynamic>;
    if(!checkId.containsKey('userId')) {
      _firebaseFirestore.doc('user/${user!.uid}').set({'userId': user!.uid});
    }
    _sharedPreferences.setBool(Constants.SPK_REGISTER_HOME, true);
    loading = false;
  }
}