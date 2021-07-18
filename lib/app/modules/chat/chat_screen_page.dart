import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:picgram/app/modules/chat/chat_store.dart';
import 'package:picgram/app/shared/loading_widget.dart';

import 'message_widget.dart';

class ChatScreenPage extends StatefulWidget {
  final Map<String, dynamic>? user;
  const ChatScreenPage({Key? key,  this.user}) : super(key: key);
  @override
  ChatScreenPageState createState() => ChatScreenPageState();
}
class ChatScreenPageState extends ModularState<ChatScreenPage, ChatStore> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user!['profilePicture'] ?? 'sem foto'),
            ),
            SizedBox(width: 20.0 * 0.75,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user!['displayName'] ?? 'sem nome', style: TextStyle(fontSize: 16)),
                Text('ativo 2h atrás', style: TextStyle(fontSize: 12))
              ],
            )
          ],
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
                  child: MessagesWidget(store: store, user: widget.user),
                )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(onPressed: () {},icon: Icon(Icons.camera_alt_outlined)),
                    SizedBox(width: 4.0),
                    Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                        hintText: 'digite uma mensagem',
                                        hintStyle: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                        enabledBorder: InputBorder.none
                                    ),
                                  )
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                  onPressed: () {
                                    store.sendMsg(widget.user!, _controller.text)
                                        .then((_) => {
                                      _controller.clear(),
                                      FocusScope.of(context).unfocus()
                                    });
                                  },
                                  icon: Icon(Icons.send_rounded),
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.64)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.photo_library_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!
                                          .withOpacity(0.64)
                                  )
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class MessagesWidget extends StatelessWidget {
  final Map<String, dynamic>? user;
  final ChatStore store;

  const MessagesWidget({
    required this.store,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: this.store.loadMessages,
    builder: (ctx, AsyncSnapshot<QuerySnapshot?> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          //return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          } else {
            final messages = snapshot.data!.docs;

            return messages.isEmpty
                ? buildText('Say Hi..')
                : ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final userLogado = this.store.user!;
                final userClicado = this.user!;
                if(message['toUser'] == userLogado.displayName && message['fromUser'] == userClicado['displayName']
                || message['fromUser'] == userLogado.displayName && message['toUser'] == userClicado['displayName']){
                  return MessageWidget(
                    message: message,
                    isMe: message['userId'] == this.store.user!.uid,
                  );
                }
                return Container();
              },
            );
          }
      }
    },
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );
}