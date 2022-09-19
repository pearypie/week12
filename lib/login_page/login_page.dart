import 'package:finalboss/login_page/header_widget.dart';
import 'package:finalboss/login_page/theme_helper.dart';
import 'package:finalboss/page2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  String useremail, userpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return maincal();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: _headerHeight,
                      child: HeaderWidget(
                          _headerHeight,
                          true,
                          Icons
                              .login_rounded), //let's create a common header widget
                    ),
                    SafeArea(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          margin: EdgeInsets.fromLTRB(
                              20, 10, 20, 10), // This will be the login form
                          child: Column(
                            children: [
                              Text(
                                'Hello',
                                style: TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Signin into your account',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 30.0),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          onSaved: (email) {
                                            useremail = email;
                                          },
                                          decoration: ThemeHelper()
                                              .textInputDecoration('User email',
                                                  'Enter your user email'),
                                        ),
                                        decoration: ThemeHelper()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: 30.0),
                                      Container(
                                        child: TextFormField(
                                          onSaved: (password) {
                                            userpassword = password;
                                          },
                                          obscureText: true,
                                          decoration: ThemeHelper()
                                              .textInputDecoration('Password',
                                                  'Enter your password'),
                                        ),
                                        decoration: ThemeHelper()
                                            .inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: 15.0),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 20),
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            "Forgot your password?",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: ThemeHelper()
                                            .buttonBoxDecoration(context),
                                        child: ElevatedButton(
                                          style: ThemeHelper().buttonStyle(),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                40, 10, 40, 10),
                                            child: Text(
                                              'Sign In'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              print('email : ${useremail}');
                                              print(
                                                  'password : ${userpassword}');
                                              singIn(useremail, userpassword);
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 20, 10, 20),
                                        //child: Text('Don\'t have an account? Create'),
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: "Don\'t have an account? "),
                                          TextSpan(
                                            text: 'Create',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrationPage()));
                                              },
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        ])),
                                      ),
                                    ],
                                  )),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future singIn(useremail, userpassword) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: useremail, password: userpassword);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        Fluttertoast.showToast(
            msg: 'ไม่มีผู้นี้ใช้ในระบบ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.toString() ==
          '[firebase_auth/unknown] Given String is empty or null') {
        Fluttertoast.showToast(
            msg: 'ไม่มีข้อมูลให้รับ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
