import 'package:picgram/app/modules/onboarding/onboarding_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => OnboardingStore(i.get<SharedPreferences>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (context, args) => OnboardingPage()),
  ];
}
