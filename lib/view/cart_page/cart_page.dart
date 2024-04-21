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
        toolbarHeight: 70.0,
        backgroundColor: Colors.pink[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
        ),
        title: Text(
          "Cart",

        ),
        centerTitle: true,
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: controller.recipelist.length,
          itemBuilder: (context, index) {
            var rec = controller.recipelist[index];
            return Card(
              color: Colors.pink[50],
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
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
                  controller.recipelist.removeAt(index);
                }, icon: Icon(Icons.delete))

              ),
            );
          },
        ),
      ),

    );
  }

}