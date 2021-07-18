import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/onboarding/onboarding_store.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  const OnboardingPage({Key? key, this.title = 'PicGram'}) : super(key: key);
  @override
  OnboardingPageState createState() => OnboardingPageState();
}
class OnboardingPageState extends ModularState<OnboardingPage, OnboardingStore> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _OnboardingItem(
            image: AssetImage('assets/social_life.png'),
            text: 'Compartilhe suas foto e momentos com todos o mundo',
            ),
          _OnboardingItem(
            image: AssetImage('assets/social_networking.png'),
            text: 'Converse com seus amigos',
            ),
          _OnboardingItem(
            image: AssetImage('assets/social_share.png'),
            text: 'Fique por dentro de tudo o que está rolando no mundo',
            child: Column(
              children: [
                ElevatedButton(onPressed: () {
                  store.markOnboardingDone();
                  Modular.to.pushReplacementNamed(Constants.Routes.REGISTER);
                }, child: Text('CADASTRE-SE')
                ),
                TextButton(onPressed: () {
                  store.markOnboardingDone();
                  Modular.to.pushNamed(Constants.Routes.LOGIN);
                }, child: Text('JÁ TEM CADASTRO?'))
              ],
            ),
            )
        ],
      )
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final ImageProvider image;
  final String text;
  final Widget? child;

  const _OnboardingItem({required this.image, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 96
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: image),
          SizedBox(height: 32),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center),
          child ?? SizedBox.fromSize(size: Size.zero)
        ],
      ),
    );
  }

}