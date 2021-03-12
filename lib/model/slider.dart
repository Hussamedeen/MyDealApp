import 'package:cloud_firestore/cloud_firestore.dart';

class Sliders {
  String title;
  String heading;
  String subheading;
  String image;
  bool isActive;
  bool isImage;
  String url;

  Sliders(
      {this.title,
      this.heading,
      this.subheading,
      this.image,
      this.isActive,
      this.isImage,
      this.url});

  factory Sliders.fromDocument(DocumentSnapshot document) {
    return Sliders(
      title: document['title'],
      heading: document["heading"],
      subheading: document["subheading"],
      isActive: document["is_active"],
      isImage: document["is_image"],
      url: document["url"],
      image: (document["image"] != null) ? document["image"]["src"] : null,
    );
  }
}
