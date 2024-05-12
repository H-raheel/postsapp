class UserModel {
  String? id;
  String? email;
  String? name;
  String? lastLoggedIn;
  List<String>? postedPosts;

  UserModel({this.id, this.email, this.name,this.postedPosts});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'postedPosts': []};
  }

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        postedPosts = List<String>.from(data['postedPosts'] ?? []);
}
