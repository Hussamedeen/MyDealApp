import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wafar_cash/ad_helper.dart';
import 'package:wafar_cash/constants.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/ui/utils/widget.dart';


import 'dealsdetails.dart';

class DealsPage extends StatefulWidget {
  final String categoryId;
  final String storeId;
  DealsPage(this.categoryId, this.storeId, {Key key}) : super(key: key);

  @override
  _DealScreen createState() => _DealScreen(this.categoryId, this.storeId);
}

class _DealScreen extends State<DealsPage> {


// TODO: Add _kAdIndex
  static final _kAdIndex = 4;

  // TODO: Add a BannerAd instance
  BannerAd _ad;

  // TODO: Add _isAdLoaded
  bool _isAdLoaded = false;

  // TODO: Add _getDestinationItemIndex()
  _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }


  final String categoryId;
  final String storeId;

  _DealScreen(this.categoryId, this.storeId);
  bool didFetchDeals = false;
  List<Coupons> fetchedDeals = [];


@override
  void dispose() {
    // TODO: implement dispose
   _ad?.dispose();
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    // TODO: Create a BannerAd instance
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (_, error) {
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // TODO: Load an ad
    _ad.load();
  }
  Future<List<Coupons>> getDeals() async {
    List<Coupons> items = [];
    var data = await Firestore.instance
        .collection("offer")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) {
      if (categoryId == null &&
          storeId == null &&
          docs.data['is_active'] == true &&
          docs.data['type'] == "d") {
        items.add(Coupons.fromDocument(docs));
      } else {
        var condition = (storeId == null)
            ? docs.data['category_id'] == categoryId
            : docs.data['store_id'] == storeId;
        if (docs.data['is_active'] == true &&
            docs.data['type'] == "d" &&
            condition) {
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
      appBar: AppBar(
        title: Text(
          'العروض',
          style: TextStyle(fontFamily: 'Almarai'),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: buildDeals(),
    );
  }

  Widget buildDeals() {
    if (this.didFetchDeals == false) {
      return FutureBuilder<List<Coupons>>(
          future: getDeals(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());
            this.didFetchDeals = true;
            this.fetchedDeals = snapshot.data;
            return (snapshot.data.length == 0)
                ? Center(
                    child: Text(
                    'No Deals exists',
                    style: h3,
                  ))
                : ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_isAdLoaded && index == _kAdIndex) {
                        return Container(
                          child: AdWidget(ad: _ad),
                          width: _ad.size.width.toDouble(),
                          height: 72.0,
                          alignment: Alignment.center,
                        );
                      } else {
                        // TODO: Get adjusted item index from _getDestinationItemIndex()
                        final item =
                            snapshot.data[_getDestinationItemIndex(index)];
                        return Card(
                          child: new GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DealsDetailPage(snapshot.data[index])),
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
                                          text:
                                              (snapshot.data[index].exclusive ==
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
                        );
                      }
                    });
          });
    } else {
      // for optimistic updating
      return Text(this.fetchedDeals.toString());
      //  ListView(children: this.fetchedCategories);
    }

  }


}

class QuerySnapshot {}
