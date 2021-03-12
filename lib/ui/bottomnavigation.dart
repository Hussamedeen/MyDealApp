import 'package:wafar_cash/ui/deals/deals.dart';
import 'package:wafar_cash/ui/stores/stores.dart';

import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/User.dart';
import 'categories/categories.dart';
import 'coupons/coupons.dart';
import 'home/HomeScreen.dart';

class BottomNavigation extends StatefulWidget {
  final User user;
  BottomNavigation({Key key, @required this.user}) : super(key: key);

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState(user);
}

class _BottomNavigationBarControllerState extends State<BottomNavigation> {
  final User user;
  _BottomNavigationBarControllerState(this.user);
  int id;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> pages = [
    HomeScreen(key: PageStorageKey('home')),
    DealsPage(null, null, key: PageStorageKey('deals')),
    CouponsPage(null, null, key: PageStorageKey('coupons')),
    CategoryPage(key: PageStorageKey('category')),
    StorePage(key: PageStorageKey('store')),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color(COLOR_PRIMARY),
        unselectedItemColor: Color(COLOR_PRIMARY).withOpacity(.50),
        selectedFontSize: 16,
        selectedLabelStyle:TextStyle(
        ),
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            label: "الرئيسية",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "عروض",
            icon: Icon(Icons.local_offer_outlined),
          ),
          BottomNavigationBarItem(
            label: "كوبونات",
            icon: Icon(Icons.money_outlined),
          ),
          BottomNavigationBarItem(
            label: "أقسام",
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            label: "متاجر",
            icon: Icon(Icons.store),
          ),
        ],
        onTap: (int index) => setState(() => _selectedIndex = index),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.black,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color: Colors
                        .yellow))), // sets the inactive color of the `BottomNavigationBar`
        child: _bottomNavigationBar(_selectedIndex),
      ),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
