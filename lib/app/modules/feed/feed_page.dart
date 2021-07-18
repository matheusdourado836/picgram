import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picgram/app/constants.dart';
import 'package:picgram/app/modules/feed/feed_store.dart';
import 'package:picgram/app/shared/loading_widget.dart';

class FeedPage extends StatefulWidget {
  final String title;
  const FeedPage({Key? key, this.title = 'PicGram'}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}
class FeedPageState extends ModularState<FeedPage, FeedStore> {

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Observer(builder: (_) {
            if(store.loading) {
              return Container(
                child: Center(
                  child: Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(color: Theme.of(context).buttonColor)),
                ),
              );
            }
            return IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt_outlined),
                              SizedBox(width: 16),
                              Text('Tirar Foto')
                            ],
                          ),
                          onTap: () async {
                            final pickedPhoto = await _picker.getImage(
                                source: ImageSource.camera,
                                imageQuality: 50,
                                maxWidth: 1920,
                                maxHeight: 1200
                            );
                            if(pickedPhoto != null) {
                              store.postPicture(pickedPhoto.path);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(height: 24),
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_outlined),
                              SizedBox(width: 16),
                              Text('Escolher da Galeria')
                            ],
                          ),
                          onTap: () async {
                            final pickedPhoto = await _picker.getImage(
                                source: ImageSource.gallery,
                                imageQuality: 50,
                                maxWidth: 1920,
                                maxHeight: 1200
                            );
                            if(pickedPhoto != null) {
                              store.postPicture(pickedPhoto.path);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          }),
          IconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () {
                Modular.to.pushNamed(Constants.Routes.CHAT);
              }
          ),
          IconButton(icon: Icon(Icons.logout),
            onPressed: () {
              store.logoff().then((_) {Modular.to.pushReplacementNamed(Constants.Routes.LOGIN);});
            },
          )
        ],
      ),
      body: Observer(
        builder: (context) {
          return StreamBuilder(
            stream: store.posts,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                log('Erro ao carregar: ${snapshot.error}');
                return Text('Deu erro!');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget();
              }
              if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Column(
                      children: [
                        FutureBuilder(
                          future: store.getUser(post['userId']),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final user = snapshot.data!.data() as Map<String, dynamic>;
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(user['profilePicture']),
                                    ),
                                    SizedBox(width: 8),
                                    Text(user['displayName'])
                                  ],
                                ),
                              );
                            }
                            return LinearProgressIndicator();
                          },
                        ),
                        SizedBox(height: 8),
                        Image.network(
                          post['url'],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite_border_outlined),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.chat_bubble_outline_outlined),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.bookmark_border_outlined),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox()
                      ],
                    );
                  },
                );
              }
              if (snapshot.hasData && snapshot.data!.docs.length == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/nothing_yet.png')),
                    SizedBox(height: 32),
                    Text(
                        'Sem Publicações ainda...',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center)
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/nothing_yet.png')),
                  SizedBox(height: 32),
                  Text(
                      'Sem Publicações ainda...',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center)
                ],
              );
            },
          );
        },
      ),
    );
  }
}