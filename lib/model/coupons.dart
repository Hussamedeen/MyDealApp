import 'package:cloud_firestore/cloud_firestore.dart';

class Coupons {
  String categoryId;
  String code;
  String description;
  bool active;
  bool exclusive;
  bool featured;
  bool verified;
  String slug;
  String storeId;
  String title;
  String type;
  String url;
  String image;
  Timestamp expire;

  Coupons(
      {this.categoryId,
      this.code,
      this.description,
      this.active,
      this.exclusive,
      this.featured,
      this.verified,
      this.slug,
      this.storeId,
      this.title,
      this.type,
      this.expire,
      this.image,
      this.url});

  factory Coupons.fromDocument(DocumentSnapshot document) {
    return Coupons(
      categoryId: document['category_id'],
      code: document['code'],
      slug: document['slug'],
      description: document['description'],
      active: document['is_active'],
      exclusive: document['is_exclusive'],
      featured: document['is_featured'],
      verified: document['is_verified'],
      storeId: document['store_id'],
      title: document['title'],
      type: document['type'],
      url: document['url'],
      image: document['image'].toString(),
      expire: document['expire_at'],
    );
  }
}
