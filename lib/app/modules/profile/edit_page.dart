import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:picgram/app/modules/profile/profile_store.dart';

class EditPage extends StatefulWidget {
  final String title;
  const EditPage({Key? key, this.title = 'Editar Perfil'}) : super(key: key);
  @override
  EditPageState createState() => EditPageState();
}
class EditPageState extends ModularState<EditPage, ProfileStore> {

  late final TextEditingController _nameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _bioController;

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();

    _picker = ImagePicker();

    _nameController = TextEditingController(text: store.user?.displayName);
    _userNameController = TextEditingController(text: store.userName);
    _bioController = TextEditingController(text: store.bio);

    reaction((_) => store.user, (_) {
      _nameController.text = store.user?.displayName ?? '';
    });

    reaction((_) => store.userName, (_) {
      _userNameController.text = store.userName ?? '';
    });

    reaction((_) => store.bio, (_) {
      _bioController.text = store.bio ?? '';
    });
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
                      child: CircularProgressIndicator(color: Theme.of(context).buttonColor),
                  ),
                ),
              );
            }
            return TextButton(onPressed: () {
              store.updateProfile(
                  displayName: _nameController.text,
                  bio: _bioController.text,
                  userName: _userNameController.text).then((_) {
                    Navigator.of(context).pop();
              });
            }, child: Text('Concluir', style: TextStyle(color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold))
            );
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            child: Observer(builder: (_) {
              if (store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                return CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(store.user!.photoURL!),
                );
              }
              return CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/sem-foto.png'),
              );
            }),
          ),
          TextButton(onPressed: () {
            showModalBottomSheet(context: context, builder: (ctx) {
              return Container(
                padding: EdgeInsets.all(16),
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
                          store.updateProfilePicture(pickedPhoto.path);
                        }
                        Navigator.of(ctx).pop();
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
                          store.updateProfilePicture(pickedPhoto.path);
                        }
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            });
          }, child: Text('Alterar Foto de Perfil')),
          _EditField(label: 'Nome', controller: _nameController, maxLength: 50,),
          _EditField(label: 'Username', controller: _userNameController, maxLength: 50,),
          _EditField(label: 'Bio', controller: _bioController, maxLength: 50,),

        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {

  String label;
  TextEditingController controller;
  int? maxLength;

  _EditField({required this.label, required this.controller, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12),
          Flexible(
              child: Container(
                child: TextFormField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    isDense: true
                  ),
                  maxLength: maxLength,
                  style: TextStyle(fontSize: 14),
                ),
              ))
        ]
      ),
    );
  }

}