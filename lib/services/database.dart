import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmediaapp/models/post.dart';
import 'package:socialmediaapp/models/user_model.dart';

class Database {
  // final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  Future<void> createUser(UserModel user) async {
    try {
      final DocumentSnapshot userSnapshot = await users.doc(user.id).get();
      if (!userSnapshot.exists)
        await users.doc(user.id).set(user.toJson());
      else {
        print("user exists");
      }
    } catch (e) {
      print("data wasnt entered");
      print(e.toString());
    }
  }

  Future<void> createPost(Post post, String? id) async {
    try {
      //final DocumentSnapshot userSnapshot = await users.doc(user.id).get();
      DocumentReference postRef = posts.doc();

      String postId = postRef.id;

      await postRef.set({
        ...post.toJson(),
        'id': postId, // Add the ID value to the post document
      });
      print(id);
      await users.doc(id).update({
        'postedPosts': FieldValue.arrayUnion([postId])
      });
    } catch (e) {
      print("data wasnt entered");
      print(id);
      print(e.toString());
    }
  }

  Future<void> editPost(String postId, Post newPost) async {
    try {
      await posts.doc(postId).update(newPost.toJson());
    } catch (e) {
      print("Failed to edit post");
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId, String? userId) async {
    try {
      // Delete the post document
      await posts.doc(postId).delete();

      // Remove the postId from the user's postedPosts array
      if (userId != null) {
        await users.doc(userId).update({
          'postedPosts': FieldValue.arrayRemove([postId])
        });
      }
    } catch (e) {
      print("Failed to delete post");
      print(e.toString());
    }
  }

  Future<List<Post>> fetchPostsFromFirestore() async {
    List<Post> postsList = [];

    try {
      QuerySnapshot querySnapshot = await posts.get();

      querySnapshot.docs.forEach((doc) {
        // Convert each document to a Post object and add it to the list
        Map<String, dynamic>? postData = doc.data() as Map<String, dynamic>;

        postsList.add(Post.fromJson({...postData, 'id': doc.id}));
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }

    return postsList;
  }

  Stream<List<Post>> getPostsStream() {
    print("loading");
    print(
        posts.snapshots().map((querySnapshot) => querySnapshot.docs.map((doc) {
              Map<String, dynamic>? postData =
                  doc.data() as Map<String, dynamic>;
              return Post.fromJson({...postData, 'id': doc.id});
            }).toList()));
    return posts
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              Map<String, dynamic>? postData =
                  doc.data() as Map<String, dynamic>;
              return Post.fromJson({...postData, 'id': doc.id});
            }).toList());
  }

  Stream<QuerySnapshot> getPostsSnapshot() {
    print("here123");
    print(posts.snapshots());
    return posts.snapshots();
  }
}
