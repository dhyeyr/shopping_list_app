


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list_app/model/user_model.dart';

import 'login&sign_model.dart';

class FsModel {
  static final _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }


  void addUser(User? user) async {


    AddUser addUsers = AddUser(
      name: user?.displayName ?? fname.text ,
      email: user?.email ?? "$email",

    );

    FirebaseFirestore.instance
        .collection("user")
        .doc(user?.uid ?? "")
        .set(addUsers.toJson());
  }



}
