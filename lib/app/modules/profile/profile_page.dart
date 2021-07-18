import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:picgram/app/modules/profile/profile_store.dart';
import 'package:picgram/app/shared/loading_widget.dart';

import '../../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends ModularState<ProfilePage, ProfileStore> {

  final padding = EdgeInsets.only(left: 16, right: 16, top: 16);

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
        title: Observer(builder: (_) {
          return Text(store.userName ?? 'Sem nome');
        }),
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
          IconButton(icon: Icon(Icons.logout),
            onPressed: () {
              store.logoff().then((_) {Modular.to.pushReplacementNamed(Constants.Routes.LOGIN);});
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _UserHeader(padding: padding, store: store),
          _UserSubHead(padding: padding, store: store),
          _UserGallery(padding: padding, store: store),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  EdgeInsets padding;
  ProfileStore store;
  _UserHeader({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 38,
            child: Observer(builder: (_) {
              if(store.user == null) {
                return LoadingWidget();
              }
              if(store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                return CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(store.user!.photoURL!),
                );
              }
              return CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/sem-foto.png'),
                backgroundColor: Colors.white70,
              );
            }),
          ),
          _UserPosts(store: store),
          Column(
            children: [
              Observer(builder: (_) => Text('${store.followers ?? 0}', style: TextStyle(fontWeight: FontWeight.bold),)),
              Text('Seguidores')
            ],
          ),
          Column(
            children: [
              Observer(builder: (_) => Text('${store.following ?? 0}', style: TextStyle(fontWeight: FontWeight.bold),)),
              Text('Seguindo')
            ],
          )
        ],
      ),
    );
  }

}

class _UserSubHead extends StatelessWidget {
  EdgeInsets padding;
  ProfileStore store;
  _UserSubHead({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Observer(builder: (_) {
            return Text(store.user?.displayName ?? 'Sem Apelido', style: TextStyle(fontWeight: FontWeight.bold));
          }),
          Observer(builder: (_) {
            return Text(store.bio ?? '');
          }),
          ElevatedButton(onPressed: () {
            Modular.to.pushNamed('.${Constants.Routes.EDIT}');
          }, child: Text('Editar Perfil'))
        ],
      ),
    );
  }
}

class _UserPosts extends StatelessWidget {
  ProfileStore store;
  _UserPosts({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: store.posts,
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError) {
              return Text('Deu Erro');
            }
            if(snapshot.hasData && snapshot.data!.docs.length == 0) {
              return Text('0', style: TextStyle(fontWeight: FontWeight.bold));
            }
            if(snapshot.hasData && snapshot.data!.docs.length > 0) {
              return Text('${snapshot.data!.docs.length}', style: TextStyle(fontWeight: FontWeight.bold));
            }
            return Container();
          },
        ),
        Text('Publicações')
      ],
    );

  }

}

class _UserGallery extends StatelessWidget {
  EdgeInsets padding;
  ProfileStore store;
  _UserGallery({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: StreamBuilder(
        stream: store.posts,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError) {
            return Text('Deu Erro');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget(message: 'Aguarde...');
          }
          if(snapshot.hasData && snapshot.data!.docs.length > 0) {
            final posts = snapshot.data!.docs;
            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: posts.map((post) {
                final data = post.data() as Map<String, dynamic>;
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Deletar'),
                          content: Text('Deseja Excluir essa Publicação?'),
                          actions: [
                            TextButton(
                              child: Text('Não'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Text('Sim'),
                              onPressed: () {
                                final scaffold = ScaffoldMessenger.of(context);
                                store.deletePost(data.values.elementAt(1).toString(), data.values.elementAt(3).toString()).then((_) => {
                                  scaffold.showSnackBar(
                                  SnackBar(
                                  content: const Text('Publicação deletada com Sucesso!'),
                                  ),
                                )
                               }
                               );
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  onTap: () {Modular.to.pushNamed('.${Constants.Routes.POSTS}');},
                  child: Image.network(data['url'] as String, fit: BoxFit.cover));
              }).toList(),
            );
          }
          if(snapshot.hasData && snapshot.data!.docs.length == 0) {
            return Column(
              children: <Widget>[
                Column(
                  children: [
                    Image.asset(Constants.Pictures.NO_DATA),
                    Text(
                      'Sem Publicações ainda...',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo[300]!.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

}