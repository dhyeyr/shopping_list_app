import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/cart_controller.dart';
import '../../model/db_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomeController controller = Get.put(HomeController());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  RxString recipeimage = ''.obs;
  DbHelper helper = DbHelper();
  Uint8List? decodeimg;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("User").get().then((value) {
      return (value) {};
    });
    controller.fetchrecipe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Recipes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: controller.recipelist.length,
          itemBuilder: (context, index) {
            var rec = controller.recipelist[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: FileImage(File(rec["image"]!)),
                ),
                title: Text("${rec["name"]}"),
                subtitle: Text(
                  "${rec["description"]}",
                  softWrap: true, // Allow text to wrap to the next line
                  maxLines: 10, // Set maximum lines to 3
                  overflow:
                  TextOverflow.ellipsis, // Add ellipsis if text overflows
                ),
                trailing: IconButton(onPressed: () async{
                  _deleteProduct(rec["id"]!);
                }, icon: Icon(Icons.delete))

              ),
            );
          },
        ),
      ),

    );
  }
  Future<void> _deleteProduct(String productId) async {
    try {
      // Reference to the Firestore collection
      var collection = FirebaseFirestore.instance.collection("User");

      // Delete the product document using its ID
      await collection.doc(productId).delete();

      // Update the UI by fetching recipes again
      controller.fetchrecipe();

      // Show a success message using GetX snackbar
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Show an error message using GetX snackbar if deletion fails
      Get.snackbar(
        'Error',
        'Failed to delete product',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}