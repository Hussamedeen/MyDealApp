import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:wafar_cash/model/stores.dart';

import '../../constants.dart';
import 'offers.dart';

class StorePage extends StatefulWidget {
  StorePage({Key key}) : super(key: key);

  @override
  _StoreScreen createState() => _StoreScreen();
}

class _StoreScreen extends State<StorePage> {
  bool didFetchStores = false;
  List<Stores> fetchedStores = [];
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('المتاجر',style: TextStyle(fontFamily: 'Almarai'),),
        backgroundColor: Color(COLOR_PRIMARY),
        centerTitle: true,
      ),
      body: buildStores(),
    );
  }

  Widget buildStores() {
    if (this.didFetchStores == false) {
      return FutureBuilder<List<Stores>>(
          future: getStores(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(backgroundColor: Colors.blue,));

            this.didFetchStores = true;
            this.fetchedStores = snapshot.data;

            return ListView.builder(
              // shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) =>
                  new GestureDetector(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OffersPage(
                                      null, snapshot.data[index].id)),
                            ),
                          },
                      child: Card(
                        child: ListTile(
                          title: Image.network(
                            (snapshot.data[index].image == null)
                                ? DEFAULT_IMAGE
                                : snapshot.data[index].image,
                            height: 100,
                          ),
                        ),
                      )),
            );
          });
    } else {
      return Text(this.fetchedStores.toString());
    }
  }
}
