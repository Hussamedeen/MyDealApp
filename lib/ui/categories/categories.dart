
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wafar_cash/model/categories.dart';
import 'package:wafar_cash/ui/stores/offers.dart';
import '../../constants.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryScreen createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryPage> {
  bool didFetchCategories = false;
  List<Categories> fetchedCategories = [];
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقسام'),
        backgroundColor: Color(COLOR_PRIMARY),
        centerTitle: true,
      ),
      body: buildCategories(),
    );
  }

  Widget buildCategories() {
    if (this.didFetchCategories == false) {
      return FutureBuilder<List<Categories>>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(backgroundColor: Colors.blue,));

            this.didFetchCategories = true;
            this.fetchedCategories = snapshot.data;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: new GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OffersPage(snapshot.data[index].id, null)),
                    )
                  },
                  child: ListTile(
                      title: Text(snapshot.data[index].title),
                      trailing: Icon(Icons.keyboard_arrow_left)),
                ),
              ),
            );
          });
    } else {
      return Text(this.fetchedCategories.toString());
    }
  }
}
