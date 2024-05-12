import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialmediaapp/models/user_model.dart';
import 'package:socialmediaapp/services/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Database dbService = Database();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      print(userCredential.user?.uid);
      print(userCredential.user?.displayName);
      if (userCredential.user != null) {
        dbService.createUser(UserModel(
          id: userCredential.user?.uid,
          email: userCredential.user?.email,
          name: userCredential.user?.displayName,
          postedPosts: [],
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
    return null;
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> LogIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        return UserModel(
            id: user.uid,
            email: user.email ?? "",
            name: user.displayName ?? "");
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print("ERRORROOROR");
    }
    return null;
  } //create User

  Future<UserModel?> signUp(
      String email, String password, String userName) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        UserModel user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            name: userName);
        await dbService.createUser(user);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print("ERRORROOROR");
    }
    return null;
  }

  //sign out

  User? getUser() {
    print(_firebaseAuth.currentUser?.email);
    return _firebaseAuth.currentUser;
  }
  //Sign In
}
