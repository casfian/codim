//import 'package:codimappp/screens/profile.dart';
import 'package:codimappp/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key, required this.returnclass}) : super(key: key);

  final String returnclass;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Login',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue,
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
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 40, 40, 10),
                            child: Text(
                              'You need to Login first.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                            child: Text(
                                'Key in your email and password if you have registered before.'),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                            child: isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                    children: [
                                      SizedBox(
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
                                                  .signIn(
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim())
                                                  .then((result) {
                                                if (result == 'Signed in!') {
                                                  //after you successful login, you will be
                                                  //resend to return class specified
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          widget.returnclass);
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
                                      // Padding(
                                      //   padding:
                                      //       EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      //   child: SizedBox(
                                      //     width:
                                      //         MediaQuery.of(context).size.width,
                                      //     height: 50,
                                      //     child: OutlinedButton(
                                      //         onPressed: () {
                                      //           Navigator.pop(context);
                                      //         },
                                      //         child: Text('Cancel')),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 20),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/register');
                                              },
                                              child: Text('New? Register Now')),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ]),
                  ),
                ))));
  }
}
