import 'package:wafar_cash/model/User.dart';
import 'package:wafar_cash/ui/services/Authenticate.dart';
import 'package:wafar_cash/ui/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../main.dart';
import 'auth/AuthScreen.dart';
import 'bottomnavigation.dart';
import 'onBoarding/OnBoardingScreen.dart';
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding = (prefs.getBool(FINISHED_ON_BOARDING) ?? false);
    if (finishedOnBoarding) {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      if (firebaseUser != null) {
        User user = await FireStoreUtils().getCurrentUser(firebaseUser.uid);
        if (user != null) {
          MyAppState.currentUser = user;
          pushReplacement(context, new BottomNavigation(user: user));
        } else {
          pushReplacement(context, new AuthScreen());
        }
      } else {
        pushReplacement(context, new AuthScreen());
      }
    } else {
      _firebaseMessaging.subscribeToTopic(COUPON_TOPIC_NOTIFICATION);
      pushReplacement(context, new OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
