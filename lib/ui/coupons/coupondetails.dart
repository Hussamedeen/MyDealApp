import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/ui/utils/helper.dart';

import '../../constants.dart';

class CouponDetailPage extends StatefulWidget {
  final Coupons coupon;
  CouponDetailPage(this.coupon);

  @override
  _CouponScreen createState() => _CouponScreen(coupon);
}

class _CouponScreen extends State<CouponDetailPage> {
  final Coupons coupon;
  bool flashCode = false;
  _CouponScreen(this.coupon);
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('تفاصيل الكوبون'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 56,
        child: Row(
          children: <Widget>[
            new GestureDetector(
              onTap: () async => {
                (coupon.code == "")
                    ? await Share.share(
                        coupon.title + " قم بزيارة المتجر الآن " + coupon.url)
                    : await Share.share(" استخدم كود الكوبون " +
                        coupon.code +
                        " لتحصل على خصم" +
                        coupon.title +
                        " قم بزيارة المتجر الآن" +
                        coupon.url),
              },
              child: Container(
                width: width / 2,
                alignment: Alignment.center,
                color: Colors.blueAccent,
                child: Text("مشاركة",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
            ),
            Expanded(
              child: new GestureDetector(
                onTap: () async => {
                  await launchURL(coupon.url),
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text("اذهب إلى المتجر",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (flashCode)
                  ? Container(
                      width: width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2.0),
                        color: Colors.lightGreen,
                      ),
                      child: Center(
                          child: Text(
                        '✅  ' + ' تم النسخ إلى الحافظة!    ' + coupon.code ,
                        style:
                            TextStyle(fontSize: 20, color: Colors.green[900]),
                      )),
                    )
                  : SizedBox(height: 10),
              SizedBox(height: 10),
              Container(
                height: 120.0,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: primaryColor,
                ),
                child: Image.network(
                  (coupon.image == null) ? DEFAULT_IMAGE : coupon.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                coupon.title,
                style: h4,
              )),
              SizedBox(height: 20),
              Center(
                  child: Text(
                removeAllHtmlTags(coupon.description),
                style: h6,
              )),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'كود الكوبون',
                  style: h4,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250.0,
                height: 60.0,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: primaryColor.withOpacity(0.3),
                ),
                child: RaisedButton(
                  child: Text(
                    (coupon.code == "") ? "GO TO THE STORE" : coupon.code,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: primaryColor)),
                  onPressed: () async => {
                    (coupon.code == "")
                        ? await launchURL(coupon.url)
                        : setState(() {
                            flashCode = true;
                          }),
                    new Timer(new Duration(seconds: 5), () {
                      setState(() {
                        flashCode = false;
                      });
                    }),
                    Clipboard.setData(new ClipboardData(text: coupon.code)),
                  },
                  color: primaryColor.withOpacity(0.5),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(3),
                  splashColor: primaryColor,
                ),
              ),
              Text(
                (coupon.code == "") ? '' : 'اضغط على الزر لنسخ الكود',
                style: TextStyle(fontSize: 15, color: primaryColor),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        (coupon.verified == true)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 40,
                              )
                            : Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 40,
                              ),
                        Text('تم التحقق', style: h5),
                      ],
                    ),
                    Column(
                      children: [
                        (coupon.exclusive == true)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 40,
                              )
                            : Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 40,
                              ),
                        Text('حصري', style: h5),
                      ],
                    ),
                    Column(
                      children: [
                        (coupon.featured == true)
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 40,
                              )
                            : Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 40,
                              ),
                        Text('متميز', style: h5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
