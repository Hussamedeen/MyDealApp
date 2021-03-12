import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/ui/coupons/coupondetails.dart';
import 'package:wafar_cash/ui/deals/dealsdetails.dart';
import 'package:wafar_cash/ui/utils/widget.dart';
import '../../constants.dart';

class OffersPage extends StatefulWidget {
  final String categoryId;
  final String storeId;
  OffersPage(this.categoryId, this.storeId, {Key key}) : super(key: key);
  @override
  _OfferScreen createState() => _OfferScreen(this.categoryId, this.storeId);
}

class _OfferScreen extends State<OffersPage> {
  final String categoryId;
  final String storeId;
  _OfferScreen(this.categoryId, this.storeId);
  bool didFetchCoupons = false;
  List<Coupons> fetchedCoupons = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Coupons>> getCoupons() async {
    List<Coupons> items = [];
    var data = await Firestore.instance
        .collection("offer")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) {
      if (categoryId == null &&
          storeId == null &&
          docs.data['is_active'] == true) {
        items.add(Coupons.fromDocument(docs));
      } else {
        var condition = (storeId == null)
            ? docs.data['category_id'] == categoryId
            : docs.data['store_id'] == storeId;
        if (docs.data['is_active'] == true && condition) {
          items.add(Coupons.fromDocument(docs));
        }
      }
    });
    for (int i = 0; i < items.length; i++) {
      var doc = await Firestore.instance
          .collection('store')
          .document(items[i].storeId)
          .get();
      items[i].image = doc.data["image"]["src"];
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('العروض'),
        backgroundColor: Color(COLOR_PRIMARY),
        centerTitle: true,
      ),
      body: buildCoupons(),
    );
  }

  Widget buildCoupons() {
    if (this.didFetchCoupons == false) {
      return FutureBuilder<List<Coupons>>(
          future: getCoupons(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());
            this.didFetchCoupons = true;
            this.fetchedCoupons = snapshot.data;
            return (snapshot.data.length == 0)
                ? Center(
                    child: Text(
                    'لا يوجد عروض الآن',
                    style: h3,
                  ))
                : ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: new GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (snapshot
                                            .data[index].type ==
                                        'c')
                                    ? CouponDetailPage(snapshot.data[index])
                                    : DealsDetailPage(snapshot.data[index])),
                          )
                        },
                        child: ListTile(
                            leading: Image.network(
                              (snapshot.data[index].image == null)
                                  ? DEFAULT_IMAGE
                                  : snapshot.data[index].image,
                              width: 120,
                            ),
                            title: Text(snapshot.data[index].title),
                            subtitle: RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: showDate(
                                          snapshot.data[index].expire)),
                                  new TextSpan(
                                      text: (snapshot.data[index].exclusive ==
                                              true)
                                          ? '    Exclusive'
                                          : '',
                                      style: new TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right)),
                      ),
                    ),
                  );
          });
    } else {
      // for optimistic updating
      return Text(this.fetchedCoupons.toString());
      //  ListView(children: this.fetchedCategories);
    }
  }
}
