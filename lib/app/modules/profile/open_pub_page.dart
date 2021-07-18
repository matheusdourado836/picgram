import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/profile/profile_store.dart';

class OpenPubPage extends StatefulWidget {
  final String title;
  const OpenPubPage({Key? key, this.title = 'Posts'}) : super(key: key);
  @override
  OpenPubPageState createState() => OpenPubPageState();
}
class OpenPubPageState extends ModularState<OpenPubPage, ProfileStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              ListTile(
                title: Text(store.firebaseAuth.currentUser!.displayName ?? 'Sem Nome', style: TextStyle(fontWeight: FontWeight.bold)),
                leading: CircleAvatar(
                  radius: 20,
                  child: Observer(builder: (_) {
                    if(store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(store.user!.photoURL!),
                      );
                    }
                    return CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/sem-foto.png'),
                      backgroundColor: Colors.white70,
                    );
                  }),
                ),
              ),
              Image.network(
                'http://lorempixel.com.br/500/400/?1',
                fit: BoxFit.fill,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_outlined))
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.messenger_outline_rounded))
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.send_outlined))
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.bookmark_border_outlined),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }
}