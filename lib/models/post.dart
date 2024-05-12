import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id; // Add ID field
  String? uploaderName;
  String? uploaderId;
  String? title;
  String? description;
  Timestamp? createdAt;
  final imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/socialmediaapp-ebf86.appspot.com/o/th.jpg?alt=media&token=47db8aa3-5587-4b50-986a-26e2338f6eb6";

  Post(
      {this.id,
      this.uploaderId,
      this.uploaderName,
      this.title,
      this.description,
      this.createdAt});

  // Constructor with named parameters
  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uploaderId = json['uploaderId'],
        uploaderName = json['uploaderName'],
        title = json['title'],
        description = json['description'],
        createdAt = json['createdAt'];

  // Convert Post object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'uploaderName': uploaderName,
        'uploaderId': uploaderId,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
      };
}
