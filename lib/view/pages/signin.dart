
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/fs_model.dart';
import '../home_page/home_page.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _LoginPageState();
}

class _LoginPageState extends State<SingUp> {
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
        title: Text("SignIn"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 150,left: 20,right: 20),
          decoration: BoxDecoration(
            // boxShadow: [BoxShadow(blurRadius: 10)],
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only( top:30,left: 20, right: 20),
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
                    UserCredential user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(email: email.text, password: password.text);
                    FsModel().addUser(user.user);
                  },
                  child: Text("Register"),
                ),
              ),



              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
