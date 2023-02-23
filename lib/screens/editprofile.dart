import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codimappp/model/user_profile.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.docref, required this.profile})
      : super(key: key);

  final String docref;
  final UserProfile profile;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var snapshot = FirebaseFirestore.instance.collection('users');

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _icnumberController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _contactnoController = TextEditingController();
  final _genderController = TextEditingController();

  void update(String useruid, String username, String email, String icnumber,
      String ethnicity, String contactno, String gender, String photo) async {
    try {
      snapshot.doc(widget.docref).update({
        'useruid': useruid,
        'username': username,
        'email': email,
        'icnumber': icnumber,
        'ethnicity': ethnicity,
        'contactno': contactno,
        'gender': gender,
        'photo': photo
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("Doc Ref::");
    print(widget.docref);

    print("Profile:::");
    print(widget.profile.useruid);

    print(widget.profile.username);
    _usernameController.text = widget.profile.username.toString();

    print(widget.profile.email);
    _emailController.text = widget.profile.email.toString();

    print(widget.profile.icnumber);
    _icnumberController.text = widget.profile.icnumber.toString();

    print(widget.profile.ethnicity);
    _ethnicityController.text = widget.profile.ethnicity.toString();

    print(widget.profile.contactno);
    _contactnoController.text = widget.profile.contactno.toString();

    print(widget.profile.gender);
    _genderController.text = widget.profile.gender.toString();

    print('=============');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile'),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              child: Text('Make sure to your Update Profile.'),
            ),
            ListTile(
              title: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'email:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _icnumberController,
                decoration: InputDecoration(
                  labelText: 'IC Number:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _ethnicityController,
                decoration: InputDecoration(
                  labelText: 'Ethnicity:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _contactnoController,
                decoration: InputDecoration(
                  labelText: 'Contact Number:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: 'Gender:',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    update(
                        widget.profile.useruid,
                        _usernameController.text,
                        _emailController.text,
                        _icnumberController.text,
                        _ethnicityController.text,
                        _contactnoController.text,
                        _genderController.text,
                        '');
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
