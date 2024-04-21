import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controller/image_controller.dart';
import '../../controller/Add_controller.dart';
import '../../model/db_helper.dart';
import '../../model/fs_model.dart';
import '../../model/login&sign_model.dart';
import '../cart_page/cart_page.dart';
import '../pages/login_page.dart';

class Home_page extends StatelessWidget {
  Home_page({super.key});

  final SignupController controller = Get.put(SignupController());
  final ImageController controller1 = Get.put(ImageController());
  final _obscureText = true.obs; // Obx for reactive state management
  late FsModel userModel = FsModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ));
            },
            icon: Icon(Icons.logout)),
        toolbarHeight: 70.0,
        backgroundColor: Colors.pink[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
        ),
        title: Text("Product List"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(Homepage());
              },
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("product").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            var detail = snapshot.data?.docs ?? [];

            return ListView.builder(
              shrinkWrap: true,
              itemCount: detail.length,
              itemBuilder: (context, index) {
                var productDetail = detail[index];
                return Card(
                  color: Colors.pink[50],
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(productDetail["image"]!)),
                    ),
                    // leading: CircleAvatar(child: Image.memory(
                    //   base64Decode(
                    //       "${productDetail?["image"]}"),
                    //   width: double.infinity,
                    //   fit: BoxFit.fitWidth,
                    // ),),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Add To Cart"),
                                  content: Text("Thank You For Your Order"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // This closes the dialog
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        DbHelper helper = DbHelper();
                                        print(fname.text);
                                        helper.insertProduct(
                                            controller.productname,
                                            controller.productdesc,
                                            controller.productimage,
                                            controller.productprice);
                                        Get.back(); // This closes the dialog
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                );
                              });

                          // // addToFavorites(HttpHeaders.fromHeader);
                        },
                        icon: Icon(Icons.add_shopping_cart_outlined)),
                    title: Text(productDetail["name"]),
                    subtitle: Text(productDetail["description"]),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomDialog();
        },
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
    );
  }

  void showCustomDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text("Add Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: controller.globalKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Obx(
                            () => CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.black12,
                              backgroundImage: filepath.isNotEmpty
                                  ? FileImage(File(filepath.value))
                                  : null,
                              child: filepath.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        pickImage(true);
                                      },
                                      icon: Icon(
                                        Icons.camera_alt_rounded,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              pickImage(false);
                            },
                            child: Text("Edit Picture"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: fname,
                      decoration: const InputDecoration(
                          labelText: "Enter Your Full Name",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: description,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: price,
                      decoration: InputDecoration(
                        labelText: "Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // This closes the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Add any action you want to perform on Okay press
              controller.goto();
              Get.back(); // This closes the dialog
            },
            child: const Text("Okay"),
          ),
        ],
      ),
      barrierDismissible:
          true, // Set to false if you don't want to dismiss the dialog by tapping outside of it
    );
  }
}
