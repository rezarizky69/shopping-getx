import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/app_constants.dart';
import 'package:untitled/constants/firebase.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/authentication/auth.dart';
import 'package:untitled/screens/home/home.dart';
import 'package:untitled/utils/helpers/showLoading.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  Rx<User> firebaseUser;
  RxBool isLoggedIn = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usersCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;

  // function yang dipanggil pertama kali
  @override
  void onReady() {
    super.onReady();
    // inisialisasi user yg terautentifikasi
    firebaseUser = Rx<User>(auth.currentUser);
    // mengikat sampai ada perubahan user
    firebaseUser.bindStream(auth.userChanges());
    // dijalankan selama ada user yg telah terautentifikasi maka menjalankan
    // function tersebut
    ever(firebaseUser, _setInitialScreen);
  }

  // set halaman yg dituju
  _setInitialScreen(User user) {
    // jika user kosong maka menuju authentication screen
    if (user == null) {
      Get.offAll(() => AuthenticationScreen());
    } else {
      // jika ada user terautentifikasi maka akan di ikat dan menjalankan semua
      // perubahan yg terjadi atas function listenToUser
      userModel.bindStream(listenToUser());
      // dan diarahkan ke home screen
      Get.offAll(() => HomeScreen());
    }
  }

  // function login
  void signIn() async {
    try {
      showLoading();
      // menggunakan email dan password
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
          // bersihkan semuanya
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  // function daftar
  void signUp() async {
    showLoading();
    try {
      // daftar dan membuat user dgn email dan password
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        // membuat userId berdasarkan hasil function createUser
        String _userId = result.user.uid;
        // menambahkan user ke firestore dengan menggunakan userId
        _addUserToFirestore(_userId);
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  // function logout
  void signOut() async {
    auth.signOut();
  }

  // function menambahkan user ke firestore dengan mengambil hasil dari
  // text controller
  _addUserToFirestore(String userId) {
    firebaseFirestore.collection(usersCollection).doc(userId).set({
      "name": name.text.trim(),
      "id": userId,
      "email": email.text.trim(),
      "cart": []
    });
  }

  // function bersihkan semua field
  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }

  // function untuk update data dari user
  updateUserData(Map<String, dynamic> data) {
    logger.i("UPDATED");
    firebaseFirestore
        .collection(usersCollection)
        .doc(firebaseUser.value.uid)
        .update(data);
  }

  // stream yg listen pada data user sehingga jika ada perubahan yang terjadi
  // di firestore akan lgsg di update ke app
  Stream<UserModel> listenToUser() => firebaseFirestore
      .collection(usersCollection)
      .doc(firebaseUser.value.uid)
      .snapshots()
      .map((snapshot) => UserModel.fromSnapshot(snapshot));
}
