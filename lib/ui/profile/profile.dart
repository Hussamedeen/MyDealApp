import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../auth/AuthScreen.dart';
import '../utils/helper.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfilePage> {
  SharedPreferences prefs;
  String uploadFileURL = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _isVerifiedController = TextEditingController();
  FirebaseUser currentUser;
  @override
  void initState() {
    super.initState();
    setInit();
  }

  setInit() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      _nameController.text = currentUser.displayName;
      _emailController.text = currentUser.email;
      _isVerifiedController.text = currentUser.isEmailVerified.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("الملف الشخصي"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: (MediaQuery.of(context).size.width) * 0.9,
              child: new Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'من فضلك أدخل بريدك الإلكتروني';
                          }
                          return null;
                        },
                        controller: _emailController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () => {
                        currentUser.updateEmail(_emailController.text),
                        showAlertDialog(context, 'تحديث الملف الشخصي',
                            'تم تحديث ملفك الشخصي'),
                      }, //since this is only a UI app
                      child: Text(
                        'تحديث الملف الشخصي',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: primaryColor,
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () => {
                        FirebaseAuth.instance.signOut(),
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => AuthScreen())),
                      }, //since this is only a UI app
                      child: Text(
                        'تسجيل خروج',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.red,
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
