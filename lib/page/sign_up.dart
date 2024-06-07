import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uidisign05/core/colors.dart';
import 'package:uidisign05/core/space.dart';
import 'package:uidisign05/core/style.dart';
import 'package:uidisign05/core/text_style.dart';
import 'package:uidisign05/widget/main_button.dart';
import 'package:uidisign05/widget/text_fild.dart';

import 'dashboard.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? name;
  String? email;
  String? phone;
  String? numSec;
  String? password;
  @override
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
                  'Create new account',
                  style: headline1,
                ),
                SpaceVH(height: 10.0),
                Text(
                  'Please fill in the form to continue',
                  style: headline3,
                ),
                SpaceVH(height: 60.0),
                textFild(
                  image: 'user.svg',
                  keyBordType: TextInputType.name,
                  hintTxt: 'Full Name',
                  onSaved: (newVal) {
                    name = newVal;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "cant be empty";
                    }
                    return null;
                  },
                ),
                textFild(
                  keyBordType: TextInputType.emailAddress,
                  image: 'user.svg',
                  hintTxt: 'Email Address',
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
                  image: 'user.svg',
                  keyBordType: TextInputType.phone,
                  hintTxt: 'social security number',
                  onSaved: (newVal) {
                    numSec = newVal;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "cant be empty";
                    }
                    return null;
                  },
                ),
                textFild(
                  image: 'user.svg',
                  keyBordType: TextInputType.phone,
                  hintTxt: 'Phone Number',
                  onSaved: (newVal) {
                    phone = newVal;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "cant be empty";
                    }
                    return null;
                  },
                ),
                textFild(
                  isObs: true,
                  image: 'hide.svg',
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
                SpaceVH(height: 50.0),
                Mainbutton(
                  onTap: () async {
                    FormState? formdata = formstate.currentState;
                    if (formdata != null) {
                      if (formdata.validate()) {
                        formdata.save();

                        try {
                          EasyLoading.show(status: "loading.....");
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          )
                              .then(
                            (value) async {
                              await FirebaseFirestore.instance
                                  .collection("patient")
                                  .add(
                                {
                                  'name': name,
                                  'email': email,
                                  'numSec': numSec,
                                  'phone': phone,
                                  'userId':
                                      FirebaseAuth.instance.currentUser!.uid,
                                },
                              ).then(
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
                            },
                          );
                        } on FirebaseAuthException catch (error) {
                          EasyLoading.dismiss();
                          error.code == 'email-already-in-use'
                              ? AwesomeDialog(
                                  context: context,
                                  title: 'Error',
                                  desc: 'Account Already Exist',
                                ).show()
                              : null;
                          error.code == 'weak-password'
                              ? AwesomeDialog(
                                  context: context,
                                  title: 'Error',
                                  desc: 'Weak Password',
                                ).show()
                              : null;
                        }
                      }
                    }
                  },
                  text: 'Sign Up',
                  btnColor: blueButton,
                ),
                SpaceVH(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Have an account? ',
                        style: headline.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: ' Sign In',
                        style: headlineDot.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
