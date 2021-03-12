import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wafar_cash/helper/styles.dart';
import 'package:wafar_cash/model/categories.dart';
import 'package:wafar_cash/model/coupons.dart';
import 'package:wafar_cash/model/slider.dart';
import 'package:wafar_cash/model/stores.dart';
import 'package:wafar_cash/ui/categories/categories.dart';
import 'package:wafar_cash/ui/coupons/coupons.dart';
import 'package:wafar_cash/ui/deals/deals.dart';
import 'package:wafar_cash/ui/profile/profile.dart';
import 'package:wafar_cash/ui/stores/stores.dart';
import 'package:wafar_cash/ui/utils/helper.dart';
import 'package:wafar_cash/ui/utils/widget.dart';
import '../../ad_state.dart';
import '../../constants.dart';
import '../auth/AuthScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  BannerAd banner;
  bool didFetchCategories = false;
  bool didFetchStores = false;
  bool didFetchCoupons = false;
  bool didFetchDeals = false;
  bool didFetchSlider = false;

  List<Categories> fetchedCategories = [];
  List<Stores> fetchedStores = [];
  List<Coupons> fetchedCoupons = [];
  List<Coupons> fetchedDeals = [];
  List<Sliders> fetchedSliders = [];
  // can be null if not loggedin


  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner= BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    } );
  }
  @override
  void initState() {
    super.initState();
  }

  Future<List<Sliders>> getSliders() async {
    List<Sliders> items = [];
    var data = await Firestore.instance.collection("banner").getDocuments();
    data.documents.forEach((DocumentSnapshot docs) {
      items.add(Sliders.fromDocument(docs));
    });
    return items;
  }

  Future<List<Categories>> getCategories() async {
    List<Categories> items = [];
    var data = await Firestore.instance
        .collection("category")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) {
      items.add(Categories.fromDocument(docs));
    });
    return items;
  }

  Future<List<Stores>> getStores() async {
    List<Stores> items = [];
    var data = await Firestore.instance
        .collection("store")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) {
      items.add(Stores.fromDocument(docs));
    });
    return items;
  }

  Future<List<Coupons>> getCoupons() async {
    List<Coupons> items = [];
    var data = await Firestore.instance
        .collection("offer")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) async {
      if (docs.data['is_featured'] == true &&
          docs.data['is_active'] == true &&
          docs.data['type'] == 'c') {
        items.add(Coupons.fromDocument(docs));
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

  Future<List<Coupons>> getDeals() async {
    List<Coupons> items = [];
    var data = await Firestore.instance
        .collection("offer")
        .orderBy('lastupdate')
        .getDocuments();
    data.documents.forEach((DocumentSnapshot docs) async {
      if (docs.data['is_featured'] == true &&
          docs.data['is_active'] == true &&
          docs.data['type'] == 'd') {
        items.add(Coupons.fromDocument(docs));
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

  Widget buildCategories() {
    if (this.didFetchCategories == false) {
      return FutureBuilder<List<Categories>>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());

            this.didFetchCategories = true;
            this.fetchedCategories = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sectionHeader('كل الأقسام', onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                }),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: listCategory(context, snapshot.data[index]),
                    ),
                  ),
                )
              ],
            );
          });
    } else {
      // for optimistic updating
      return Text('تحميل...');
    }
  }

  Widget buildStores() {
    if (this.didFetchStores == false) {
      return FutureBuilder<List<Stores>>(
          future: getStores(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center, child: Text(''));

            this.didFetchStores = true;
            this.fetchedStores = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sectionHeader('كل المتاجر', onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StorePage()),
                  );
                }),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: listStore(context, snapshot.data[index]),
                    ),
                  ),
                )
              ],
            );
          });
    } else {
      // for optimistic updating
      return Text(this.fetchedStores.toString());
    }
  }

  Widget buildCoupons() {
    if (this.didFetchCoupons == false) {
      return FutureBuilder<List<Coupons>>(
          future: getCoupons(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center, child: Text(''));

            this.didFetchCoupons = true;
            this.fetchedCoupons = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sectionHeader('كل الكوبونات', onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CouponsPage(null, null)),
                  );
                }),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: listCoupons(context, snapshot.data[index]),
                    ),
                  ),
                )
              ],
            );
          });
    } else {
      // for optimistic updating
      return Text(this.fetchedCoupons.toString());
      //  ListView(children: this.fetchedCategories);
    }
  }

  Widget buildDeals() {
    if (this.didFetchDeals == false) {
      return FutureBuilder<List<Coupons>>(
          future: getDeals(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center, child: Text(''));

            this.didFetchDeals = true;
            this.fetchedDeals = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                sectionHeader('كل العروض', onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DealsPage(null, null)),
                  );
                }),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: listDeals(context, snapshot.data[index]),
                    ),
                  ),
                )
              ],
            );
          });
    } else {
      // for optimistic updating
      return Text(this.fetchedCoupons.toString());
      //  ListView(children: this.fetchedCategories);
    }
  }

  Widget buildSlider() {
    if (this.didFetchSlider == false) {
      return FutureBuilder<List<Sliders>>(
          future: getSliders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center, child: Text(''));

            this.didFetchSlider = true;
            this.fetchedSliders = snapshot.data;
            return CarouselSlider.builder(
              itemCount: snapshot.data.length,
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () => {
                  launchURL(snapshot.data[index].url),
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(
                            8.0) //                 <--- border radius here
                        ),
                  ),
                  child: (snapshot.data[index].isImage == true)
                      ? Image.network(
                          (snapshot.data[index].image == null)
                              ? DEFAULT_IMAGE
                              : snapshot.data[index].image,
                          fit: BoxFit.fill,
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: Icon(
                              Icons.local_offer,
                              color: Colors.white,
                            ),
                            title: Text(
                              snapshot.data[index].title,
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              snapshot.data[index].heading,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
            );
          });
    } else {
      return Text(this.fetchedSliders.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget sectionHeader(String headerTitle, {onViewMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 15, top: 10),
          child: Text(headerTitle, style: h4),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 2),
          child: FlatButton(
            onPressed: onViewMore,
            child: Text('شاهد الكل >', style: contrastText),
          ),
        )
      ],
    );
  }

  Widget headerCategoryItem(String name, Widget icon, {onPressed}) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 86,
              height: 86,
              child: FloatingActionButton(
                shape: CircleBorder(),
                heroTag: name,
                onPressed: onPressed,
                backgroundColor: Colors.white,
                child: icon,
              )),
          Text(name + ' ›', style: categoryText)
        ],
      ),
    );
  }

  Widget deals(String dealTitle, {onViewMore, List<Widget> items}) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          sectionHeader(dealTitle, onViewMore: onViewMore),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (items != null)
                  ? items
                  : <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text('لا توجد عناصر متاحة في هذه اللحظة.',
                            style: taglineText),
                      )
                    ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // IconButton(
          //     icon: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Navigator.push<Widget>(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SearchPage(),
          //         ),
          //       );
          //     }),
          IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () async {
                var user = await FirebaseAuth.instance.currentUser();
                // print(user.uid);
                (user == null)
                    ? Navigator.push<Widget>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      )
                    : Navigator.push<Widget>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
              }),
        ],
        title: Text(
          'الرئيسية',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(COLOR_PRIMARY),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                buildSlider(),
                if(banner==null)
                  SizedBox(height: 50.0,)
                else
                  Container(
                    height: 50.0,
                    child: AdWidget(ad: banner,),
                  ),
                buildCategories(),
                buildCoupons(),
                buildStores(),
                buildDeals(),
              ],
            ),
          ),

        ]),
      ),
    );
  }


  // final BannerAd myBanner = BannerAd(
  //   adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: AdListener(),
  // );
}
