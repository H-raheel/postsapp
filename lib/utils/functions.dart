import 'package:cloud_firestore/cloud_firestore.dart';

String getTimeAgo(Timestamp timestamp) {
  DateTime createdAt = timestamp.toDate();
  Duration difference = DateTime.now().difference(createdAt);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} min ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hour ago";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} day ago";
  } else if (difference.inDays < 365) {
    int months = difference.inDays ~/ 30;
    return "$months month ago";
  } else {
    int years = difference.inDays ~/ 365;
    return "$years year ago";
  }
}
