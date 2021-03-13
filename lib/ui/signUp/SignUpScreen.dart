//import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../../constants.dart';
import '../../model/User.dart';
import '../bottomnavigation.dart';
import '../services/Authenticate.dart';
import '../utils/helper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import '../../constants.dart' as Constants;
import '../../main.dart';

File _image;

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  String firstName, lastName, email, mobile, password, confirmPassword;
  final _fireStoreUtils = FireStoreUtils();

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            autovalidateMode: AutovalidateMode.always,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

  Widget formUI() {
    return new Column(
      children: <Widget>[
        new Align(
            alignment: Alignment.topRight,
            child: Text(
              'تسجيل حساب جديد',
              style: TextStyle(
                  color: Color(Constants.COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 18.0),
                    validator: validateName,
                    onSaved: (String val) {
                      firstName = val;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,

                        hintText: 'الاسم الأول',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 18.0),

                    validator: validateName,
                    onSaved: (String val) {
                      lastName = val;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'الاسم الأخير',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        // ConstrainedBox(
        //     constraints: BoxConstraints(minWidth: double.infinity),
        //     child: Padding(
        //         padding:
        //             const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        //         child: TextFormField(
        //             keyboardType: TextInputType.phone,
        //             textInputAction: TextInputAction.next,
        //             onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        //             validator: validateMobile,
        //             onSaved: (String val) {
        //               mobile = val;
        //             },
        //             decoration: InputDecoration(
        //                 contentPadding: new EdgeInsets.symmetric(
        //                     vertical: 8, horizontal: 16),
        //                 fillColor: Colors.white,
        //                 hintText: 'Mobile Number',
        //                 focusedBorder: OutlineInputBorder(
        //                     borderRadius: BorderRadius.circular(25.0),
        //                     borderSide: BorderSide(
        //                         color: Color(Constants.COLOR_PRIMARY),
        //                         width: 2.0)),
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(25.0),
        //                 ))))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                    style: TextStyle(fontSize: 18.0),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        fillColor: Colors.white,
                        hintText: 'البريد الإلكتروني',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))))),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  controller: _passwordController,
                  validator: validatePassword,
                  onSaved: (String val) {
                    password = val;
                  },
                  style: TextStyle(height: 0.8, fontSize: 18.0),
                  cursorColor: Color(Constants.COLOR_PRIMARY),
                  decoration: InputDecoration(
                      contentPadding:
                          new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      fillColor: Colors.white,
                      hintText: 'كلمة المرور',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Color(Constants.COLOR_PRIMARY),
                              width: 2.0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
            )),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _sendToServer();
                },
                obscureText: true,
                validator: (val) =>
                    validateConfirmPassword(_passwordController.text, val),
                onSaved: (String val) {
                  confirmPassword = val;
                },
                style: TextStyle(height: 0.8, fontSize: 18.0),
                cursorColor: Color(Constants.COLOR_PRIMARY),
                decoration: InputDecoration(
                    contentPadding:
                        new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    fillColor: Colors.white,
                    hintText: 'تأكيد كلمة المرور',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Color(Constants.COLOR_PRIMARY), width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: primaryColor,
              child: Text(
                'تسجيل حساب جديد',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: primaryColor,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: primaryColor)),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(32.0),
        //   child: Center(
        //     child: Text(
        //       'أو من خلال',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
        //   child: ConstrainedBox(
        //     constraints: const BoxConstraints(minWidth: double.infinity),
        //     child: RaisedButton.icon(
        //       label: Text(
        //         'تسجيل من فيسبوك',
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
        //             showProgress(context, 'تسجيل الدخول ، الرجاء الانتظار ...', false);
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
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'إنشاء حساب جديد ...', false);
      var profilePicUrl = '';
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (_image != null) {
          updateProgress('جارٍ تحميل الصورة ...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, result.user.uid);
        }
        User user = User(
            email: email,
            firstName: firstName,
            phoneNumber: mobile,
            userID: result.user.uid,
            active: true,
            lastName: lastName,
            settings: Settings(allowPushNotifications: true),
            profilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .document(result.user.uid)
            .setData(user.toJson());
        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, BottomNavigation(user: user), false);
      } catch (error) {
        hideProgress();
        (error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'فشل', 'تعذر التسجيل')
            : showAlertDialog(context, 'فشل',
                'البريد الاليكتروني قيد الاستخدام. الرجاء اختيار عنوان بريد إلكتروني آخر');
        print(error.toString());
      }
    }
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

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
}
