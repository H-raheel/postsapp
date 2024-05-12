import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/models/post.dart';
import 'package:socialmediaapp/screens/home.dart';
import 'package:socialmediaapp/services/authService.dart';
import 'package:socialmediaapp/services/database.dart';
import 'package:socialmediaapp/utils/widgets.dart';

class CreatePostScreen extends StatefulWidget {
  final Post? post;
  final bool update;
  CreatePostScreen({super.key, this.post, required this.update});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _titleController = new TextEditingController();

  TextEditingController _descController = new TextEditingController();

  final String? userName = AuthService().getUser()?.displayName;

  final String? id = AuthService().getUser()?.uid;

  final String? email = AuthService().getUser()?.email;

  Database dbService = Database();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.update) {
      _titleController.text = widget.post?.title ?? "";
      _descController.text = widget.post?.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 224, 224),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 230, 224, 224),
        centerTitle: true,
        title: Text("Post", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // TextField(
                //   controller: _titleController,
                // ),
                InputField(
                  inputController: _titleController,
                  size: 20,
                  text: "Enter Title",
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  inputController: _descController,
                  size: 30,
                  text: "Enter description",
                ),
                SizedBox(
                  height: 20,
                ),
                // TextField(
                //   controller: _descController,
                // ),
                ElevatedButton(
                    onPressed: () async {
                      if (!widget.update) {
                        await dbService.createPost(
                            Post(
                                uploaderId: id,
                                uploaderName: userName,
                                title: _titleController.text,
                                description: _descController.text,
                                createdAt: Timestamp.now()),
                            id);
                      } else {
                        await dbService.editPost(
                          widget.post?.id ?? "",
                          Post(
                            id: widget.post
                                ?.id, // Include the post ID to identify the post
                            title: _titleController.text, // Update the title
                            description:
                                _descController.text, // Update the description
                            createdAt: Timestamp
                                .now(), // Update the createdAt timestamp
                            uploaderId: widget.post?.uploaderId,
                            uploaderName: widget.post?.uploaderName,
                          ), // Spread operator to copy all other fields from the original post
                        );
                      }

                      if (!mounted) {
                        return;
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: widget.update
                        ? Text(
                            "Update Post",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 221, 136, 75)),
                          )
                        : Text(
                            "Create Post",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 221, 136, 75)),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
