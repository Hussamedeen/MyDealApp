import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  String id;
  String title;
  String slug;
  String image;
  bool isActive;

  Categories({this.id, this.title, this.slug, this.image, this.isActive});

  factory Categories.fromDocument(DocumentSnapshot document) {
    return Categories(
      id: document.documentID,
      title: document["title"],
      slug: document["slug"],
      isActive: document["is_active"],
      image: document["image"]["src"],
    );
  }
}
