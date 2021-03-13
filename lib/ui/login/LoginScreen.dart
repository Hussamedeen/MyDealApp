//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../../model/User.dart';
import '../bottomnavigation.dart';
import '../services/Authenticate.dart';
import '../utils/helper.dart';
//import 'package:http/http.dart' as http;

import '../../constants.dart' as Constants;
import '../../main.dart';

final _fireStoreUtils = FireStoreUtils();

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'تسجيل الدخول',
                style: TextStyle(
                    color: Color(Constants.COLOR_PRIMARY),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    controller: _emailController,
                    style: TextStyle(fontSize: 18.0),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'أدخل بريدك الالكتروني',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    obscureText: true,
                    textAlignVertical: TextAlignVertical.center,
                    validator: validatePassword,
                    onSaved: (String val) {
                      password = val;
                    },
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'ادخل كلمة المرور',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Color(Constants.COLOR_PRIMARY),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  splashColor: Color(Constants.COLOR_PRIMARY),
                  onPressed: () async {
                    await onClick(
                        _emailController.text, _passwordController.text);
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color(Constants.COLOR_PRIMARY))),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(32.0),
            //   child: Center(
            //     child: Text(
            //       'أو من خلال حسابك على الفيسبوك',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding:
            //       const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
            //   child: ConstrainedBox(
            //     constraints: const BoxConstraints(minWidth: double.infinity),
            //     child: RaisedButton.icon(
            //       label: Text(
            //         'تسجيل الدخول بالفيسبوك',
            //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //       ),
            //       icon: Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 8.0),
            //         child: Image.asset(
            //           'assets/images/facebook_logo.png',
            //           color: Colors.white,
            //           height: 30,
            //           width: 30,
            //         ),
            //       ),
            //       color: Color(Constants.FACEBOOK_BUTTON_COLOR),
            //       textColor: Colors.white,
            //       splashColor: Color(Constants.FACEBOOK_BUTTON_COLOR),
            //       onPressed: () async {
            //         final facebookLogin = FacebookLogin();
            //         final result = await facebookLogin.logIn(['email']);
            //         switch (result.status) {
            //           case FacebookLoginStatus.loggedIn:
            //             showProgress(
            //                 context, 'تسجيل الدخول ، الرجاء الانتظار ...', false);
            //             await FirebaseAuth.instance
            //                 .signInWithCredential(
            //                     FacebookAuthProvider.getCredential(
            //                         accessToken: result.accessToken.token))
            //                 .then((AuthResult authResult) async {
            //               User user = await _fireStoreUtils
            //                   .getCurrentUser(authResult.user.uid);
            //               if (user == null) {
            //                 _createUserFromFacebookLogin(
            //                     result, authResult.user.uid);
            //               } else {
            //                 _syncUserDataWithFacebookData(result, user);
            //               }
            //             });
            //             break;
            //           case FacebookLoginStatus.cancelledByUser:
            //             break;
            //           case FacebookLoginStatus.error:
            //             showAlertDialog(
            //                 context, 'خطأ', 'لا يمكن تسجيل الدخول عبر الفيسبوك.');
            //             break;
            //         }
            //       },
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(25.0),
            //           side: BorderSide(
            //               color: Color(Constants.FACEBOOK_BUTTON_COLOR))),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  onClick(String email, String password) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'تسجيل الدخول ، يرجى الانتظار ...', false);
      User user =
          await loginWithUserNameAndPassword(email.trim(), password.trim());
      if (user != null)
        pushAndRemoveUntil(context, BottomNavigation(user: user), false);
    }
  }

  Future<User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .document(result.user.uid)
          .get();
      User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data);
        user.active = true;
        await _fireStoreUtils.updateCurrentUser(user, context);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } catch (exception) {
      hideProgress();
      switch ((exception as PlatformException).code) {
        case 'ERROR_INVALID_EMAIL':
          showAlertDialog(context, 'خطأ', 'عنوان البريد الإلكتروني غير صحيح.');
          break;
        case 'ERROR_WRONG_PASSWORD':
          showAlertDialog(context, 'خطأ',
              'كلمة السر غير متطابقة. الرجاء كتابة كلمة المرور الصحيحة.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          showAlertDialog(context, 'خطأ',
              'لا يوجد مستخدم مطابق لعنوان البريد الإلكتروني المحدد. الرجاء التسجيل أولا.');
          break;
        case 'ERROR_USER_DISABLED':
          showAlertDialog(context, 'خطأ', 'تم تعطيل هذا المستخدم');
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showAlertDialog(context, 'خطأ',
              'كانت هناك محاولات كثيرة جدًا لتسجيل الدخول  لهذا المستخدم.');
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showAlertDialog(
              context, 'خطأ', 'لم يتم تمكين حسابات البريد الإلكتروني وكلمة المرور');
          break;
      }
      print(exception.toString());
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _createUserFromFacebookLogin(
  //     FacebookLoginResult result, String userID) async {
  //   final token = result.accessToken.token;
  //   final graphResponse = await http.get('https://graph.facebook.com/v2'
  //       '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
  //   final profile = json.decode(graphResponse.body);
  //   var user = {
  //     "firstName": profile['first_name'],
  //     "lastName": profile['last_name'],
  //     "email": profile['email'],
  //     "profilePictureURL": profile['picture']['data']['url'],
  //     "active": true,
  //     "id": userID
  //   };
  //   await FireStoreUtils.firestore
  //       .collection(Constants.USERS)
  //       .document(userID)
  //       .setData(user)
  //       .then((onValue) {
  //     MyAppState.currentUser = User.fromJson(user);
  //     hideProgress();
  //     pushAndRemoveUntil(
  //         context, BottomNavigation(user: User.fromJson(user)), false);
  //   });
  // }
  //
  // void _syncUserDataWithFacebookData(
  //     FacebookLoginResult result, User user) async {
  //   final token = result.accessToken.token;
  //   final graphResponse = await http.get('https://graph.facebook.com/v2'
  //       '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
  //   final profile = json.decode(graphResponse.body);
  //   user.profilePictureURL = profile['picture']['data']['url'];
  //   user.firstName = profile['first_name'];
  //   user.lastName = profile['last_name'];
  //   user.email = profile['email'];
  //   user.active = true;
  //   await _fireStoreUtils.updateCurrentUser(user, context);
  //   MyAppState.currentUser = user;
  //   hideProgress();
  //   pushAndRemoveUntil(context, BottomNavigation(user: user), false);
  // }
}
