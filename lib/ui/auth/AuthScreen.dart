import 'package:flutter/material.dart';
import '../bottomnavigation.dart';
import '../utils/helper.dart';

import '../../constants.dart' as Constants;
import '../login/LoginScreen.dart';
import '../signUp/SignUpScreen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              height: height * 0.3,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: new Image.asset(
                  'assets/images/logo.png',
                  height: 110.0,
                ),
              ),
            ),
            Text(
              'أهلا وسهلا بكم',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(Constants.COLOR_PRIMARY),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'يمكنك تسجيل الدخول أو التسجيل للتحقق من العروض',
                style: TextStyle(fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Color(Constants.COLOR_PRIMARY),
                  child: Text(
                    'تسجيل دخول',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  splashColor: Color(Constants.COLOR_PRIMARY),
                  onPressed: () {
                    push(context, new LoginScreen());
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color(Constants.COLOR_PRIMARY))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: FlatButton(
                  textColor: Colors.black54,
                  child: Text(
                    'تسجيل حساب جديد',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    push(context, new SignUpScreen());
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: FlatButton(
                  textColor: Colors.black54,
                  child: Text(
                    'تخطي',
                  ),
                  onPressed: () {
                    pushReplacement(
                        context,
                        new BottomNavigation(
                          user: null,
                        ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
