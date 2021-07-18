import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/chat/chat_screen_page.dart';
import 'package:picgram/app/modules/chat/chat_store.dart';
import 'package:picgram/app/shared/loading_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  ChatPageState createState() => ChatPageState();
}
class ChatPageState extends ModularState<ChatPage, ChatStore> {

  bool _searching = false;

  late final TextEditingController _searchingController;

  @override
  void initState() {
    super.initState();
    _searchingController = TextEditingController();
    _searchingController.addListener(() {
      final query = _searchingController.text;
      store.search(query);
    });
  }

  Widget _searchField() {
    final color = Theme.of(context).buttonColor;
    return TextFormField(
      controller: _searchingController,
      decoration: InputDecoration(
          icon: Icon(Icons.search, color: color),
          fillColor: color,
          focusColor: color,
          hoverColor: color
      ),
      cursorColor: color,
      style: TextStyle(color: color),
    );
  }

  late Widget _searchingWidget = Observer(
    builder: (_) {
      return StreamBuilder(
        stream: store.searchResult,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Deu erro!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }

          if (snapshot.hasData && snapshot.data!.docs.length > 0) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return Column(
                  children: [
                    FutureBuilder(
                      future: store.getUser(user['userId']),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data!.data() as Map<String, dynamic>;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: InkWell(
                                child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: NetworkImage(user['profilePicture']),
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(user['displayName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          Text('Ativo 1h atrás', style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                      Spacer(),
                                      IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined))
                                    ]
                                ),
                                onTap: () {
                                  store.adicionarChat(user);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreenPage(user: user)));
                                }
                            ),
                          );
                        }
                        return LinearProgressIndicator();
                      },
                    ),
                  ],
                );
              },
            );
          }
          return Container();
        },
      );
    },
  );

  late Widget _notSearching = StreamBuilder(
    stream: store.carregarChats,
    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasError) {
        return Text('DEU ERRO!');
      }
      if(snapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget();
      }
      if(snapshot.data!.docs.length == 0) {
        return Text('VACIO');
      }
      if(snapshot.hasData && snapshot.data!.docs.length > 0) {
        final chats = snapshot.data!.docs;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return Column(
              children: [
                FutureBuilder(
                  future: store.getUser(chat['userId']),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data!.data() as Map<String, dynamic>;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: InkWell(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(user['profilePicture']),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['displayName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                  Text('Ativo 1h atrás', style: TextStyle(fontSize: 16))
                                ],
                              ),
                              Spacer(),
                              IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined))
                          ]
                        ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreenPage(user: user)));
                          }
                      ),
                      );
                    }
                    return LinearProgressIndicator();
                    },
                  ),
                ],
            );
          },
        );
      }
      return Container();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching ? _searchField() : Text(store.user!.displayName ?? 'Sem Nome'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
              });
            },
          )
        ],
      ),
      body: _searching ? _searchingWidget : _notSearching,
    );
  }
}