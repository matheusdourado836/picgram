import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:picgram/app/modules/register/register_store.dart';

import '../../constants.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key? key, this.title = 'Faça  seu Cadastro'}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends ModularState<RegisterPage, RegisterStore> {

  late PageController _pageController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passController;

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    
    _disposer = when(
        (_) => store.user != null,
        () => Modular.to.pushReplacementNamed('.${Constants.Routes.HOME}')
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  late final Widget _form = PageView(
    controller: _pageController,
    scrollDirection: Axis.vertical,
    //Usuario nao vai controlar o Scroll
    physics: NeverScrollableScrollPhysics(),
    children: [
      _FormField(
        label: 'Qual é o seu nome?',
        showsBackButton: false,
        controller: _nameController,
        onNext: () {
          _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      ),
      _FormField(
        label: 'Qual é o seu E-mail?',
        controller: _emailController,
        onNext: () {
          _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
        onBack: () {
          _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      ),
      _FormField(
        label: 'Qual vai ser sua Senha?',
        controller: _passController,
        hidePass: true,
        onNext: () {
          store.registerUser(
              nome: _nameController.text,
              email: _emailController.text,
              password: _passController.text
          );
        },
        onBack: () {
          _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(onPressed: () {
            Modular.to.pushNamed(Constants.Routes.LOGIN);
          }, child: Text('Já sou cadastrado', style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Aguarde... salvando seu cadastro')
                ],
              ),
            );
          }else {
            return _form;
          }
        },
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool hidePass;
  final bool showsBackButton;
  final TextEditingController controller;

  const _FormField({
    required this.label,
    required this.onNext,
    this.onBack,
    this.showsBackButton = true,
    this.hidePass = false,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showsBackButton ? _backButton() : SizedBox.fromSize(size: Size.zero),
        Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 40),
                      maxLines: 1,
                    ),
                  ),
                  TextFormField(
                    controller: controller,
                    onEditingComplete: onNext,
                    style: TextStyle(fontSize: 32),
                    obscureText: hidePass,
                  )
                ],
              ),
            )
        )
      ],
    );
  }

  Widget _backButton() {
    return IconButton(onPressed: onBack, icon: Icon(Icons.arrow_upward));
  }


}