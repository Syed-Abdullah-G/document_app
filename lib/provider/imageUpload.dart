

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/models/imageUpload.dart';

part 'imageUpload.g.dart';

@riverpod
class imageUploader extends _$imageUploader with ChangeNotifier {
 
 @override
 uploadFile build() {
  return uploadFile(filePaths: []);
 }


 void addData(List<String>? filePaths) {
  state = uploadFile(filePaths: filePaths);
  notifyListeners();
 }

}