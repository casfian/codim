import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codimappp/model/user_profile.dart';
import 'package:codimappp/screens/editprofile.dart';
import 'package:codimappp/screens/login.dart';
import 'package:codimappp/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io' as io;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late bool isLogin = false;
  late User _user;

  //check if login or not
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('at profile, FirebaseUser::');
      if (user == null) {
        print('User is signed out!');
        setState(() {
          isLogin = false;
        });
      } else {
        print('User is signed in!');

        setState(() {
          isLogin = true;
          _user = user;
          print(_user.uid);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? Profilewidget(docref: _user.uid)
        : Login(returnclass: '/profile');
  }
}

class Profilewidget extends StatefulWidget {
  Profilewidget({Key? key, this.docref}) : super(key: key);
  final String? docref;
  @override
  _ProfilewidgetState createState() => _ProfilewidgetState();
}

class _ProfilewidgetState extends State<Profilewidget> {
  File? imageFile;
  firebase_storage.Reference? _storage = firebase_storage
      .FirebaseStorage.instance
      .ref('gs://codimapp-a45b0.appspot.com/')
      .child('profiles')
      .child('/IMG_4725.JPG');

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
      print(imageFile);
    });
    Navigator.pop(context);
  }

  void _openAlbum(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
      print(imageFile);
    });

    Navigator.pop(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile!.path);
    _storage = firebase_storage.FirebaseStorage.instance
        .ref('gs://codimapp-a45b0.appspot.com/')
        .child('profiles')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    uploadTask = _storage!.putFile(io.File(imageFile!.path), metadata);

    //firebase_storage.UploadTask task= await Future.value(uploadTask);

    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _profileStream = FirebaseFirestore.instance
        .collection('users')
        .where('useruid', isEqualTo: widget.docref)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationProvider>().signOut();
              Navigator.popAndPushNamed(context, '/');
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _profileStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                print('Document ID:');
                print(document.id);
                print('============');
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xCCCCCFCC),
                        child: imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  imageFile!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (_) => CupertinoActionSheet(
                                            title: Text('Select Photo From'),
                                            message:
                                                Text('The Following Source'),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                  isDefaultAction: true,
                                                  onPressed: () {
                                                    //camera
                                                    _openCamera(context);
                                                  },
                                                  child: Text('Camera')),
                                              CupertinoActionSheetAction(
                                                  isDefaultAction: false,
                                                  onPressed: () {
                                                    //photo album
                                                    _openAlbum(context);
                                                  },
                                                  child: Text('Photo Album')),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ));
                                },
                                icon: Icon(Icons.photo_camera, color: Colors.blue[400],)),
                      ),
                      
                      TextButton(
                          onPressed: () {
                            UserProfile _profile = UserProfile(
                                data['useruid'].toString(),
                                data['username'].toString(),
                                data['gender'].toString(),
                                data['ethnicity'].toString(),
                                data['email'].toString(),
                                data['icnumber'].toString(),
                                data['contactno'].toString(),
                                data['photo'].toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                          docref: document.id.toString(),
                                          profile: _profile,
                                        )));
                          },
                          child: Text('Edit Profile')),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Username',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['username'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['email'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'IC Number',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['icnumber'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Ethnicity',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['ethnicity'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Contact Number',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['contactno'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Gender',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(data['gender'].toString().toUpperCase()),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
