import 'package:cloud_firestore/cloud_firestore.dart';

class Stores {
  String id;
  String title;
  String slug;
  String image;
  bool isActive;
  bool isFeatured;
  String storeUrl;

  Stores({
    this.id,
    this.title,
    this.slug,
    this.image,
    this.isActive,
    this.isFeatured,
    this.storeUrl,
  });

  factory Stores.fromDocument(DocumentSnapshot document) {
    return Stores(
      id: document.documentID,
      title: document["title"],
      slug: document["slug"],
      image: document["image"]["src"],
      isFeatured: document["is_featured"],
      isActive: document["is_active"],
      storeUrl: document["store_url"],
    );
  }
}
