import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codimappp/screens/profile.dart';
import 'package:codimappp/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void createprofile(String? useruid, String? email) async {
    
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc().set({
        'useruid': useruid,
        'username': '',
        'email': email,
        'contactno': '',
        'ethnicity': '',
        'gender': '',
        'icnumber': '',
        'photo': '',
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Register',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                            child: Text(
                                'Key in your email and password to register.'),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email:',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Email Address';
                                } else if (!value.contains('@')) {
                                  return 'Please enter a valid email address!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password:',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters!';
                                }
                                return null;
                              },
                            ),
                          ),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 20, 40, 10),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.lightBlue)),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              context
                                                  .read<
                                                      AuthenticationProvider>()
                                                  .signUp(
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim())
                                                  .then((result) {
                                                if (result == "Signed up!") {
                                                  
                                                  FirebaseAuth.instance
                                                      .authStateChanges()
                                                      .listen((User? user) {
                                                    setState(() {
                                                      print('useruid:');
                                                      print(user!.uid);                        
                                                      print('------');
                                                      createprofile(user.uid, user.email);
                                                    });
                                                  });

                                                  //create user here
                                                  
                                                  //then go to profile page
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile()));
                                                } else {
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          result.toString()));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  print(result);
                                                }
                                              });
                                            }
                                          },
                                          child: Text('Submit'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 20, 40, 20),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: OutlinedButton(
                                            // style: ButtonStyle(
                                            //     backgroundColor:
                                            //         MaterialStateProperty
                                            //             .all<Color>(Colors
                                            //                 .grey.shade400)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel')),
                                      ),
                                    ),
                                  ],
                                ),
                        ]),
                  ),
                ))));
  }
}
