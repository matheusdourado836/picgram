// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedStore on _FeedStoreBase, Store {
  final _$loadingAtom = Atom(name: '_FeedStoreBase.loading');

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

  final _$userAtom = Atom(name: '_FeedStoreBase.user');

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

  final _$postsAtom = Atom(name: '_FeedStoreBase.posts');

  @override
  Stream<QuerySnapshot<Object?>> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(Stream<QuerySnapshot<Object?>> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  final _$_loadFeedAsyncAction = AsyncAction('_FeedStoreBase._loadFeed');

  @override
  Future<void> _loadFeed() {
    return _$_loadFeedAsyncAction.run(() => super._loadFeed());
  }

  final _$postPictureAsyncAction = AsyncAction('_FeedStoreBase.postPicture');

  @override
  Future<void> postPicture(String filePath) {
    return _$postPictureAsyncAction.run(() => super.postPicture(filePath));
  }

  final _$logoffAsyncAction = AsyncAction('_FeedStoreBase.logoff');

  @override
  Future<void> logoff() {
    return _$logoffAsyncAction.run(() => super.logoff());
  }

  final _$_FeedStoreBaseActionController =
      ActionController(name: '_FeedStoreBase');

  @override
  void _onUserChange(User? user) {
    final _$actionInfo = _$_FeedStoreBaseActionController.startAction(
        name: '_FeedStoreBase._onUserChange');
    try {
      return super._onUserChange(user);
    } finally {
      _$_FeedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
user: ${user},
posts: ${posts}
    ''';
  }
}
