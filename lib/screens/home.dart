import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/models/post.dart';
import 'package:socialmediaapp/screens/createPost.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/services/authService.dart';
import 'package:socialmediaapp/services/database.dart';
import 'package:socialmediaapp/utils/functions.dart';

import '../utils/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Stream<List<Post>> postsStream;
  Stream? postsStream2;
  Database dbService = Database();
  @override
  void initState() {
    super.initState();
    // getontheload();
  }

  final user = AuthService().getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 224, 224),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 221, 136, 75),
              )),
        ],
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 230, 224, 224),
      ),
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: MediaQuery.of(context).size.height *
                0.25, // 3/4 of the screen height
            left: 0,
            right: 0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight:
                              FontWeight.bold, // Adjust font size as needed
                          color: Color.fromARGB(
                              255, 118, 118, 118), // Default color
                        ),
                        children: [
                          TextSpan(
                            text: "Hey ",
                          ),
                          TextSpan(
                            text: "${user?.displayName}",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Color.fromARGB(255, 221, 136,
                                  75), // Change color of display name
                              fontWeight: FontWeight
                                  .bold, // Optionally apply other styles
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Start exploring resources",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            elevation: 2,
                            child: searchBar(),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Icon(
                            Icons.filter_alt,
                            color: const Color.fromARGB(255, 221, 136, 75),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 12),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Latest Uploads ⚡",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Stream(dbService: dbService, user: user),
                ],
              ),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePostScreen(
                      post: null,
                      update: false,
                    )),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Icon(
            Icons.add,
            color: const Color.fromARGB(255, 221, 136, 75),
          ),
        ),
      ),
    );
  }
}



class Stream extends StatelessWidget {
  const Stream({
    super.key,
    required this.dbService,
    required this.user,
  });

  final Database dbService;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dbService.getPostsSnapshot(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No posts to display"),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                Post post = Post.fromJson(
                    {...data, 'id': snapshot.data!.docs[index].id});
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PostWidget(post: post, user: user),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.user,
  });

  final Post post;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(post.uploaderId);

        print(user?.uid);
        if (post.uploaderId == user?.uid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePostScreen(
                      post: post,
                      update: true,
                    )),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 230, 224, 224),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.imageUrl),
                    ),
                    Text(post.uploaderName ?? "",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    const Spacer(),
                    Text(
                      getTimeAgo(post.createdAt ?? Timestamp.now()),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    )
                  ],
                ),
                Text(
                  post.title ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(post.description ?? "",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 230, 224, 224),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.heart_broken,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.chat_bubble,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
