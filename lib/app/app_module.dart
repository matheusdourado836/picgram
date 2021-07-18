import 'package:picgram/app/modules/chat/chat_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/login/login_module.dart';
import 'package:picgram/app/modules/onboarding/onboarding_module.dart';
import 'package:picgram/app/modules/register/register_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picgram/app/shared/util/app_route_guard.dart';

import 'modules/chat/chat_module.dart';
import 'modules/feed/feed_module.dart';
import 'modules/home/home_module.dart';
import 'modules/profile/profile_module.dart';
import 'modules/search/search_module.dart';

class AppModule extends Module {
  SharedPreferences _sharedPreferences;
  FirebaseApp _firebaseApp;
  AppModule(this._sharedPreferences, this._firebaseApp);

  late final _routeGuard = AppRouteGuard(FirebaseAuth.instance);

  @override
  List<Bind> get binds => [
        Bind.singleton((i) => _sharedPreferences),
        Bind.instance(_firebaseApp),
        Bind.factory((i) => FirebaseAuth.instance),
        Bind.factory((i) => FirebaseFirestore.instance),
        Bind.factory((i) => FirebaseStorage.instance),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: _initialModule()),
        ModuleRoute(Constants.Routes.HOME,
            module: HomeModule(), guards: [_routeGuard]),
        ModuleRoute(Constants.Routes.ONBOARDING, module: OnboardingModule()),
        ModuleRoute(Constants.Routes.REGISTER,
            module: RegisterModule(),
            transition: TransitionType.rightToLeftWithFade),
        ModuleRoute(Constants.Routes.LOGIN, module: LoginModule()),
        ModuleRoute(Constants.Routes.FEED,
            module: FeedModule(), guards: [_routeGuard]),
        ModuleRoute(Constants.Routes.CHAT,
            module: ChatModule(), guards: [_routeGuard]),
        ModuleRoute(Constants.Routes.SEARCH,
            module: SearchModule(), guards: [_routeGuard]),
        ModuleRoute(Constants.Routes.PROFILE,
            module: ProfileModule(), guards: [_routeGuard]),
      ];

  Module _initialModule() {
    final onBoardingDone =
        _sharedPreferences.getBool(Constants.SPK_ONBOARDING_DONE) ?? false;
    if (onBoardingDone) {
      final registerDone =
          _sharedPreferences.getBool(Constants.SPK_REGISTER_HOME) ?? false;
      if (registerDone) {
        return LoginModule();
      } else {
        return RegisterModule();
      }
    } else {
      return OnboardingModule();
    }
  }
}
