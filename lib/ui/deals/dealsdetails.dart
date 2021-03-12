
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/ui/utils/helper.dart';

import '../../constants.dart';

class DealsDetailPage extends StatefulWidget {
  final Coupons coupon;
  DealsDetailPage(this.coupon);

  @override
  _DealDetailScreen createState() => _DealDetailScreen(coupon);
}

class _DealDetailScreen extends State<DealsDetailPage> {
  final Coupons coupon;
  _DealDetailScreen(this.coupon);
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
        title: Text('تفاصيل العرض'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 56,
        // margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            new GestureDetector(
              onTap: () async => {
                await Share.share(
                    coupon.title + " visit store now " + coupon.url)
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
                  child: Text("اذهب إلى العرض",
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
              SizedBox(height: 50),
              Container(
                height: 120.0,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: primaryColor,
                ),
                child: Image.network(
                  (coupon.image == null) ? DEFAULT_IMAGE : coupon.image,
                  // height: 150.0,
                  // width: 100.0,
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
                    "زيارة المتجر",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: primaryColor)),
                  onPressed: () async => {
                    await launchURL(coupon.url),
                  },
                  color: primaryColor.withOpacity(0.5),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(3),
                  splashColor: primaryColor,
                ),
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
