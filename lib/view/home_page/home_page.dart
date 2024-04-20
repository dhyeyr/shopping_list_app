import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/image_controller.dart';
import '../../controller/Add_controller.dart';
import '../../model/db_helper.dart';
import '../../model/fs_model.dart';
import '../../model/login&sign_model.dart';

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
        title: Text("home page"),
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
                  child: ListTile(
                    // leading: CircleAvatar(child: Image.memory(
                    //   base64Decode(
                    //       "${productDetail?["image"]}"),
                    //   width: double.infinity,
                    //   fit: BoxFit.fitWidth,
                    // ),),
                    trailing: IconButton(
                        onPressed: () {

                          addToFavorites(HttpHeaders.fromHeader);
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
                        controller: pnumber,
                        decoration: const InputDecoration(
                            labelText: "Enter Your Number",
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return "* Plz Enter Your Phone Number";
                          } else if (value?.length != 10) {
                            return "* Invalid Phone Number";
                          } else {
                            return null;
                          }
                        }),
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
  List<String> getAllCategories(List allQuote) {
    Set<String> categoriesSet = <String>{};
    for (var quoteModel in allQuote) {
      categoriesSet.addAll(quoteModel.categories ?? []);
    }
    return categoriesSet.toList();
  }

  List<String> getAllBackgroundImages(List allQuote) {
    List<String> backgroundImages = [];
    for (var quoteModel in allQuote) {
      backgroundImages.addAll(quoteModel.bgImages ?? []);
    }
    return backgroundImages;
  }

  void addToFavorites(String quote) async {
    bool added = await DbHelper.instance.insertData(quote);
    // if (added) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Quote added to favorites'),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Quote is already in favorites'),
    //     ),
    //   );
    }

}
