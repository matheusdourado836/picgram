import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/constants.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _onTabChange(_currentIndex);
  }

  @override
  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: Modular.to.navigate('${Constants.Routes.HOME}${Constants.Routes.FEED}'); break;
      case 1: Modular.to.navigate('${Constants.Routes.HOME}${Constants.Routes.SEARCH}'); break;
      case 2: Modular.to.navigate('${Constants.Routes.HOME}${Constants.Routes.PROFILE}'); break;
      default: break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _onTabChange,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'feed'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'pesquisar'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'perfil'
          )
        ],
      ),
    );
  }
}