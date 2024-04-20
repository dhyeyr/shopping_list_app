
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

TextEditingController email = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController fname = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController newPassword = TextEditingController();
TextEditingController pnumber = TextEditingController();

RxString filepath = "".obs;

void pickImage(bool isCamara) async {
  XFile? file = await ImagePicker()
      .pickImage(source: isCamara ? ImageSource.camera : ImageSource.gallery);
  filepath.value = file!.path;


}

