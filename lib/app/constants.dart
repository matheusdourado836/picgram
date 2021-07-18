abstract class Constants {
  //SPK = SHARED PREFERENCES KEY
  static const SPK_ONBOARDING_DONE = 'OnboaringDone';
  static const SPK_REGISTER_HOME = 'RegisterDone';

  static final Routes = _Routes();
  static final Pictures = _Pictures();
}

class _Routes {
  final HOME = '/home';
  final ONBOARDING = '/onboarding';
  final REGISTER = '/register';
  final LOGIN = '/login';
  final FORGOT_PASSWORD = '/login/forgot_password';
  final CHAT = '/chat';

  final FEED = '/feed';
  final SEARCH = '/search';
  final PROFILE = '/profile';
  final EDIT = '/edit';
  final POSTS = '/open_pub';
  final CHAT_SCREEN = '/chat_screen';
}

class _Pictures {
  final LOGIN = 'assets/login.png';
  final FORGOT_PASSWORD = 'assets/forgot_pass.png';
  final NOTHING_YET = 'assets/nothing_yet.png';
  final PROGRESS = 'assets/progress.png';
  final VOID = 'assets/void.png';
  final NO_DATA = 'assets/no-data.png';
}