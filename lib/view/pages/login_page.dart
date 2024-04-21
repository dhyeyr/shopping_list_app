import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_list_app/view/pages/signin.dart';

import '../../model/fs_model.dart';
import '../home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.pink[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
        ),
        centerTitle: true,
        title: Text("User Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 120,left: 20,right: 20),
          decoration: BoxDecoration(
            // boxShadow: [BoxShadow(blurRadius: 10)],
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only( top:20,left: 20, right: 20),
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Obx(
                      () => TextFormField(
                    controller: password,
                    obscureText: _obscureText.value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _obscureText.toggle(); // Toggle password visibility
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 40,
                width: 360,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ))),
                  onPressed: () async {
                    try {
                      UserCredential user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      print("user Login==> ${user.user}");
                      FsModel().addUser(user.user);
                      Get.to(Home_page());
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      print(e.message);
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "New User ?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              InkWell(
                  onTap: () async {
                    Get.to(SingUp());
                  },
                  child: Text(
                    "Signup Now",
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  )),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  endIndent: 15,
                  indent: 15,
                  thickness: 1.7,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () async {
                    var cu = FirebaseAuth.instance.currentUser;
                    print(cu);

                    if (cu != null) {
                      print("Already Login");
                    } else {
                      var google = await GoogleSignIn().signIn();
                      var auth = await google?.authentication;
                      var credential = GoogleAuthProvider.credential(
                          accessToken: auth?.accessToken,
                          idToken: auth?.idToken);
                      var data = await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      print(data);
                      FsModel().addUser(data.user);
                      print(google?.displayName);
                      print(google?.photoUrl);
                      print("object $google");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home_page()));
                    }
                  },
                  child: Image(
                    image: AssetImage("assets/google.png"),
                    width: 35,
                    height: 35,
                  )),
              Text(
                "Signin With Google",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
