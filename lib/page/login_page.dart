import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uidisign05/core/colors.dart';
import 'package:uidisign05/core/space.dart';
import 'package:uidisign05/core/text_style.dart';
import 'package:uidisign05/page/dashboard.dart';
import 'package:uidisign05/page/sign_up.dart';
import 'package:uidisign05/widget/text_fild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? email;
  String? password;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBG,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
            child: Form(
          key: formstate,
          child: Column(
            children: [
              SpaceVH(height: 50.0),
              Text(
                'Welcome Back!',
                style: headline1,
              ),
              SpaceVH(height: 10.0),
              Text(
                'Please sign in to your account',
                style: headline3,
              ),
              SpaceVH(height: 60.0),
              textFild(
                image: 'user.svg',
                hintTxt: 'Email',
                onSaved: (newVal) {
                  email = newVal;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "cant be empty";
                  }
                  return null;
                },
              ),
              textFild(
                image: 'hide.svg',
                isObs: true,
                hintTxt: 'Password',
                onSaved: (newVal) {
                  password = newVal;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "cant be empty";
                  }
                  return null;
                },
              ),
              SpaceVH(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: headline3,
                    ),
                  ),
                ),
              ),
              SpaceVH(height: 100.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        FormState? formdata = formstate.currentState;
                        if (formdata != null) {
                          if (formdata.validate()) {
                            formdata.save();

                            try {
                              EasyLoading.show(status: "loading.....");
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email!,
                                password: password!,
                              )
                                  .then(
                                (value) {
                                  EasyLoading.dismiss();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DashBoard(),
                                    ),
                                  );
                                },
                              );
                            } on FirebaseAuthException catch (error) {
                              EasyLoading.dismiss();
                              error.code == 'user-not-found'
                                  ? AwesomeDialog(
                                      context: context,
                                      title: 'Error',
                                      desc: ' user not found',
                                    ).show()
                                  : null;

                              error.code == 'wrong-password'
                                  ? AwesomeDialog(
                                      context: context,
                                      title: 'Error',
                                      desc: 'Wrong Password',
                                    ).show()
                                  : null;
                            }
                          }
                        }
                      },
                      child: Text('Sign in'),
                    ),
                    SpaceVH(height: 20.0),
                  ],
                ),
              ),
              Align(
                child: Column(
                  children: [
                    SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignUpPage()));
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Don\' have an account? ',
                            style: headline.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Sign Up',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
