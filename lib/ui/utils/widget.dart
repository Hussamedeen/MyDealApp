import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wafar_cash/constants.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/categories.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/model/stores.dart';
import 'package:wafar_cash/ui/coupons/coupondetails.dart';
import 'package:wafar_cash/ui/deals/dealsdetails.dart';
import 'package:wafar_cash/ui/stores/offers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget listStore(BuildContext context, Stores store) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OffersPage(null, store.id)));
    },
    child: Container(
      width: 180,
      height: 180,
      child: Stack(
        children: <Widget>[
          Container(
              color: Colors.white,
              width: 180,
              height: 180,
              child: Hero(
                transitionOnUserGestures: true,
                tag: store.title,
                child: Image.network(
                    (store.image == null) ? DEFAULT_IMAGE : store.image),
              )),
        ],
      ),
    ),
  );
}

Widget listCategory(BuildContext context, Categories category) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OffersPage(category.id, null)));
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Container(
              color: Colors.white,
              child: Hero(
                transitionOnUserGestures: true,
                tag: category.title,
                child: Image.network(
                  (category.image == null) ? DEFAULT_IMAGE : category.image,
                  fit: BoxFit.fill,
                ),
              )),
        ],
      ),
    ),
  );
}

Widget listCoupons(BuildContext context, Coupons coupon) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CouponDetailPage(coupon)),
      );
    },
    child: Container(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          (coupon.image == null) ? DEFAULT_IMAGE : coupon.image,
                        ),
                        fit: BoxFit.fitWidth),
                    color: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("exclusive",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 110),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          coupon.title,
                          style: h6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 35,
                        color: (calDay(coupon.expire) < 2)
                            ? Colors.green.shade600
                            : primaryColor,
                        child: Center(
                          child: Text(
                            showDate(coupon.expire),
                            style: TextStyle(
                              color: Colors.white,
                              // backgroundColor: primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget listDeals(BuildContext context, Coupons coupon) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DealsDetailPage(coupon)),
      );
    },
    child: Container(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          (coupon.image == null) ? DEFAULT_IMAGE : coupon.image,
                        ),
                        fit: BoxFit.fitWidth),
                    color: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("exclusive",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 110),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          coupon.title,
                          style: h6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 35,
                        color: primaryColor,
                        child: Center(
                          child: Text(
                            " Go to the Deal                >",
                            style: TextStyle(
                              color: Colors.white,
                              // backgroundColor: primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

int calDay(Timestamp timestamp) {
  int year = timestamp.toDate().year;
  int month = timestamp.toDate().month;
  int day = timestamp.toDate().month;
  final birthday = DateTime(year, month, day);
  final date2 = DateTime.now();
  final difference = date2.difference(birthday).inDays;
  return difference;
}

String showDate(Timestamp timestamp) {
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  int year = timestamp.toDate().year;
  int month = timestamp.toDate().month;
  int day = timestamp.toDate().day;
  return "Valid Till : " +
      day.toString() +
      " " +
      months[month - 1] +
      ", " +
      year.toString();
}
