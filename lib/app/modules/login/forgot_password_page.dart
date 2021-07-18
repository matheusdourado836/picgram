import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/login/login_store.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String title;
  const ForgotPasswordPage({Key? key, this.title = 'Recupere a sua Senha'}) : super(key: key);
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}
class ForgotPasswordPageState extends ModularState<ForgotPasswordPage, LoginStore> {

  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: ListView(
          children: [
            Text(
              'Não se preocupe!',
              style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 32),
            ),
            Image.asset(Constants.Pictures.FORGOT_PASSWORD),
            Text(
              'Vamos te enviar um link para redefinir a sua senha...',
              style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Qual é o seu email?'
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  store.resetPassword(email: _emailController.text)
                      .then((_) {
                        showDialog(context: context, builder: (_) {
                          return AlertDialog(
                            title: Text('E-mail Enviado'),
                            content: Text('Siga as instruções no seu e-mail'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Modular.to.pop(); //fecha o dialog
                                    Modular.to.pop(); //volta para a tela de login
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  });
                },
                child: Text('Redefinir a Senha'))
          ],
        ),
      ),
    );
  }
}