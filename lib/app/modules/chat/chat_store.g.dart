// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStoreBase, Store {
  Computed<Stream<QuerySnapshot<Object?>>>? _$loadMessagesComputed;

  @override
  Stream<QuerySnapshot<Object?>> get loadMessages => (_$loadMessagesComputed ??=
          Computed<Stream<QuerySnapshot<Object?>>>(() => super.loadMessages,
              name: '_ChatStoreBase.loadMessages'))
      .value;
  Computed<Stream<QuerySnapshot<Object?>>>? _$carregarChatsComputed;

  @override
  Stream<QuerySnapshot<Object?>> get carregarChats =>
      (_$carregarChatsComputed ??= Computed<Stream<QuerySnapshot<Object?>>>(
              () => super.carregarChats,
              name: '_ChatStoreBase.carregarChats'))
          .value;

  final _$loadingAtom = Atom(name: '_ChatStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$userAtom = Atom(name: '_ChatStoreBase.user');

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$searchResultAtom = Atom(name: '_ChatStoreBase.searchResult');

  @override
  Stream<QuerySnapshot<Object?>> get searchResult {
    _$searchResultAtom.reportRead();
    return super.searchResult;
  }

  @override
  set searchResult(Stream<QuerySnapshot<Object?>> value) {
    _$searchResultAtom.reportWrite(value, super.searchResult, () {
      super.searchResult = value;
    });
  }

  final _$searchAsyncAction = AsyncAction('_ChatStoreBase.search');

  @override
  Future<void> search(String query) {
    return _$searchAsyncAction.run(() => super.search(query));
  }

  final _$sendMsgAsyncAction = AsyncAction('_ChatStoreBase.sendMsg');

  @override
  Future<void> sendMsg(Map<String, dynamic> userRceived, String message) {
    return _$sendMsgAsyncAction.run(() => super.sendMsg(userRceived, message));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
user: ${user},
searchResult: ${searchResult},
loadMessages: ${loadMessages},
carregarChats: ${carregarChats}
    ''';
  }
}
