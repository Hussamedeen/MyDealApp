import 'package:flutter/material.dart';
import '../utils/helper.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart' as Constants;
import '../auth/AuthScreen.dart';

final _currentPageNotifier = ValueNotifier<int>(0);

final List<String> _titlesList = Constants.onBoardingText;
final List<String> _subtitlesList = Constants.onBoardingSubTitleText;

final List<IconData> _imageList = [
  Icons.add_shopping_cart_outlined,
  Icons.local_offer_outlined,
  Icons.monetization_on_outlined
];
final List<Widget> _pages = [];

List<Widget> populatePages(BuildContext context) {
  _pages.clear();
  _titlesList.asMap().forEach((index, value) => _pages.add(getPage(
      _imageList.elementAt(index), value, _subtitlesList.elementAt(index))));
  _pages.add(getLastPage(context));
  return _pages;
}

Widget _buildCircleIndicator() {
  return CirclePageIndicator(
    selectedDotColor: Constants.primaryColor,
    dotColor: Constants.primaryColor,
    selectedSize: 8,
    size: 6.5,
    itemCount: _pages.length,
    currentPageNotifier: _currentPageNotifier,
  );
}

Widget getPage(IconData icon, String title, String subTitle) {
  return Center(
    child: Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: new Icon(
                  icon,
                  color: Constants.primaryColor,
                  size: 120,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  subTitle,
                  style:
                      TextStyle(color: Constants.primaryColor, fontSize: 17.0),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget getLastPage(BuildContext context) {
  return Center(
    child: Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: new Image.asset(
                  'assets/images/logo.png',
                  height: 200.0,
                ),
              ),
              Text(
                'لنبدأ الآن',
                style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlineButton(
                    onPressed: () {
                      setFinishedOnBoarding();
                      pushReplacement(context, new AuthScreen());
                    },
                    child: Text(
                      "البدء",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    borderSide: BorderSide(color: Constants.primaryColor),
                    shape: StadiumBorder(),
                  ))
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> setFinishedOnBoarding() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(Constants.FINISHED_ON_BOARDING, true);
}

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        PageView(
          children: populatePages(context),
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildCircleIndicator(),
          ),
        )
      ],
    ));
  }
}
